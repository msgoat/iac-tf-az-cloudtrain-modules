locals {
  node_cpu_request = "${(var.elasticsearch_node_cpu / 2) * 1000}m"
  node_cpu_limit = "${var.elasticsearch_node_cpu * 1000}m"
  node_ram_request = "${var.elasticsearch_node_ram}Gi"
  node_ram_limit = "${var.elasticsearch_node_ram}Gi"
  node_storage_size = "${var.elasticsearch_node_storage_size}Gi"
  es_protocol = var.elasticsearch_tls_enabled ? "https" : "http"
  es_hostname = "${var.elasticsearch_cluster_name}-master.${var.kubernetes_namespace_name}"
  es_port = 9200
  es_url = "${local.es_protocol}://${local.es_hostname}:${local.es_port}"
  # render helm chart values since direct passing of values does not work in all cases
  rendered_values = <<EOT
clusterName: "${var.elasticsearch_cluster_name}"
nodeGroup: "master"

# The service that non master groups will try to connect to when joining the cluster
# This should be set to clusterName + "-" + nodeGroup for your master group
masterService: ""

# Elasticsearch roles that will be applied to this nodeGroup
# These will be set as environment variables. E.g. node.roles=master
# https://www.elastic.co/guide/en/elasticsearch/reference/current/modules-node.html#node-roles
roles:
  - master
  - data
replicas: ${var.elasticsearch_cluster_size}

# Allows you to add any config files in /usr/share/elasticsearch/config/
# such as elasticsearch.yml and log4j2.properties
esConfig: {}
#  elasticsearch.yml: |
#    xpack.security.enabled: ${var.elasticsearch_security_enabled}

createCert: ${var.elasticsearch_tls_enabled}

esJvmOptions: {}
#  processors.options: |
#    -XX:ActiveProcessorCount=3

# Extra environment variables to append to this nodeGroup
# This will be appended to the current 'env:' key. You can use any of the kubernetes env
# syntax here
extraEnvs:
  - name: bootstrap.memory_lock
    value: "false"
  # provide Elasticsearch username and password via Kubernetes secret
  - name: ELASTIC_PASSWORD
    valueFrom:
      secretKeyRef:
        name: ${kubernetes_secret.elasticsearch.metadata.0.name}
        key: password
  - name: ELASTIC_USERNAME
    valueFrom:
      secretKeyRef:
        name: ${kubernetes_secret.elasticsearch.metadata.0.name}
        key: username

# Allows you to load environment variables from kubernetes secret or config map
envFrom: []
# - secretRef:
#     name: env-secret
# - configMapRef:
#     name: config-map

# Disable it to use your own elastic-credential Secret.
secret:
  enabled: false

# A list of secrets and their paths to mount inside the pod
# This is useful for mounting certificates for security and for mounting
# the X-Pack license
secretMounts: []
#  - name: elastic-certificates
#    secretName: elastic-certificates
#    path: /usr/share/elasticsearch/config/certs
#    defaultMode: 0755

podAnnotations: {}
# iam.amazonaws.com/role: es-cluster

# additionals labels
labels: {}

esJavaOpts: "" # example: "-Xmx1g -Xms1g"

resources:
  requests:
    cpu: "${local.node_cpu_request}"
    memory: "${local.node_ram_request}"
  limits:
    cpu: "${local.node_cpu_limit}"
    memory: "${local.node_ram_limit}"

initResources: {}
# limits:
#   cpu: "25m"
#   # memory: "128Mi"
# requests:
#   cpu: "25m"
#   memory: "128Mi"

networkHost: "0.0.0.0"

volumeClaimTemplate:
  storageClassName: "${var.elasticsearch_node_storage_class}"
  accessModes: ["ReadWriteOnce"]
  resources:
    requests:
      storage: "${local.node_storage_size}"

rbac:
  create: true
  serviceAccountAnnotations: {}
  serviceAccountName: ""
  automountToken: true

podSecurityPolicy:
  create: false
  name: ""
  spec:
    privileged: true
    fsGroup:
      rule: RunAsAny
    runAsUser:
      rule: RunAsAny
    seLinux:
      rule: RunAsAny
    supplementalGroups:
      rule: RunAsAny
    volumes:
      - secret
      - configMap
      - persistentVolumeClaim
      - emptyDir

persistence:
  enabled: true
  labels:
    # Add default labels for the volumeClaimTemplate of the StatefulSet
    enabled: false
  annotations: {}

extraVolumes: []
# - name: extras
#   emptyDir: {}

extraVolumeMounts: []
# - name: extras
#   mountPath: /usr/share/extras
#   readOnly: true

extraContainers: []
# - name: do-something
#   image: busybox
#   command: ['do', 'something']

extraInitContainers: []
# - name: do-something
#   image: busybox
#   command: ['do', 'something']

# This is the PriorityClass settings as defined in
# https://kubernetes.io/docs/concepts/configuration/pod-priority-preemption/#priorityclass
priorityClassName: ""

# By default this will make sure two pods don't end up on the same node
# Changing this to a region would allow you to spread pods across regions
antiAffinityTopologyKey: "kubernetes.io/hostname"

# Hard means that by default pods will only be scheduled if there are enough nodes for them
# and that they will never end up on the same node. Setting this to soft will do this "best effort"
antiAffinity: ${var.topology_spread_strategy}

# This is the node affinity settings as defined in
# https://kubernetes.io/docs/concepts/configuration/assign-pod-node/#node-affinity-beta-feature
%{ if var.node_group_workload_class != "" ~}
# Encourages deployment to the tools pool
nodeAffinity:
  requiredDuringSchedulingIgnoredDuringExecution:
    nodeSelectorTerms:
      - matchExpressions:
          - key: "group.msg.cloud.kubernetes/workload"
            operator: In
            values:
              - ${var.node_group_workload_class}
%{ endif ~}

# The default is to deploy all pods serially. By setting this to parallel all pods are started at
# the same time when bootstrapping the cluster
podManagementPolicy: "Parallel"

# The environment variables injected by service links are not used, but can lead to slow Elasticsearch boot times when
# there are many services in the current namespace.
# If you experience slow pod startups you probably want to set this to `false`.
enableServiceLinks: true

protocol: ${local.es_protocol}
httpPort: ${local.es_port}
transportPort: 9300

service:
  enabled: true
  labels: {}
  labelsHeadless: {}
  type: ClusterIP
  # Consider that all endpoints are considered "ready" even if the Pods themselves are not
  # https://kubernetes.io/docs/reference/kubernetes-api/service-resources/service-v1/#ServiceSpec
  publishNotReadyAddresses: false
  nodePort: ""
  annotations: {}
  httpPortName: http
  transportPortName: transport
  loadBalancerIP: ""
  loadBalancerSourceRanges: []
  externalTrafficPolicy: ""

updateStrategy: RollingUpdate

# This is the max unavailable setting for the pod disruption budget
# The default value of 1 will make sure that kubernetes won't allow more than 1
# of your pods to be unavailable during maintenance
maxUnavailable: 1

podSecurityContext:
  fsGroup: 1000
  runAsUser: 1000

securityContext:
  capabilities:
    drop:
      - ALL
  # readOnlyRootFilesystem: true
  runAsNonRoot: true
  runAsUser: 1000

# How long to wait for elasticsearch to stop gracefully
terminationGracePeriod: 120

sysctlVmMaxMapCount: 262144

readinessProbe:
  failureThreshold: 3
  initialDelaySeconds: 10
  periodSeconds: 10
  successThreshold: 3
  timeoutSeconds: 5

# https://www.elastic.co/guide/en/elasticsearch/reference/current/cluster-health.html#request-params wait_for_status
clusterHealthCheckParams: "wait_for_status=green&timeout=1s"

imagePullSecrets: []
nodeSelector: {}
%{ if var.node_group_workload_class != "" ~}
# It's OK to be deployed to the tools pool, too
tolerations:
  - key: "group.msg.cloud.kubernetes/workload"
    operator: "Equal"
    value: ${var.node_group_workload_class}
    effect: "NoSchedule"
%{ endif ~}

# Enabling this will publicly expose your Elasticsearch instance.
# Only enable this if you have security enabled on your cluster
ingress:
  enabled: ${var.public_access_enabled}
%{ if var.public_access_enabled ~}
  annotations:
    kubernetes.io/ingress.class: nginx
  hosts:
    - host: "${var.public_access_host}"
      paths:
        - path: "/elasticsearch/${var.kubernetes_namespace_name}/${var.elasticsearch_cluster_name}"
%{ endif ~}

nameOverride: ""
fullnameOverride: ""
healthNameOverride: ""

sysctlInitContainer:
  enabled: true

keystore: []

networkPolicy:
  ## Enable creation of NetworkPolicy resources. Only Ingress traffic is filtered for now.
  ## In order for a Pod to access Elasticsearch, it needs to have the following label:
  ## {{ template "uname" . }}-client: "true"
  ## Example for default configuration to access HTTP port:
  ## elasticsearch-master-http-client: "true"
  ## Example for default configuration to access transport port:
  ## elasticsearch-master-transport-client: "true"

  http:
    enabled: false
    ## if explicitNamespacesSelector is not set or set to {}, only client Pods being in the networkPolicy's namespace
    ## and matching all criteria can reach the DB.
    ## But sometimes, we want the Pods to be accessible to clients from other namespaces, in this case, we can use this
    ## parameter to select these namespaces
    ##
    # explicitNamespacesSelector:
    #   # Accept from namespaces with all those different rules (only from whitelisted Pods)
    #   matchLabels:
    #     role: frontend
    #   matchExpressions:
    #     - {key: role, operator: In, values: [frontend]}

    ## Additional NetworkPolicy Ingress "from" rules to set. Note that all rules are OR-ed.
    ##
    # additionalRules:
    #   - podSelector:
    #       matchLabels:
    #         role: frontend
    #   - podSelector:
    #       matchExpressions:
    #         - key: role
    #           operator: In
    #           values:
    #             - frontend

  transport:
    ## Note that all Elasticsearch Pods can talk to themselves using transport port even if enabled.
    enabled: false
    # explicitNamespacesSelector:
    #   matchLabels:
    #     role: frontend
    #   matchExpressions:
    #     - {key: role, operator: In, values: [frontend]}
    # additionalRules:
    #   - podSelector:
    #       matchLabels:
    #         role: frontend
    #   - podSelector:
    #       matchExpressions:
    #         - key: role
    #           operator: In
    #           values:
    #             - frontend

tests:
  enabled: true
EOT
}

resource helm_release elasticsearch {
  chart = "elasticsearch"
  version = "8.5.1"
  repository = "https://helm.elastic.co"
  name = var.helm_release_name
  dependency_update = true
  atomic = true
  cleanup_on_fail = true
  namespace = var.kubernetes_namespace_name
  create_namespace = true
  values = [ local.rendered_values ]
}