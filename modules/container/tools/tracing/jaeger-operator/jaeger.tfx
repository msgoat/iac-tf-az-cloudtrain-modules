locals {
  helm_values = <<EOT
# Default values for jaeger.
# This is a YAML-formatted file.
# Jaeger values are grouped by component. Cassandra values override subchart values

provisionDataStore:
  cassandra: false
  elasticsearch: false
  kafka: false

# Overrides the image tag where default is the chart appVersion.
tag: ""

nameOverride: ""
fullnameOverride: ""

storage:
  # allowed values (cassandra, elasticsearch)
  type: elasticsearch
  elasticsearch:
    scheme: http
    host: ${module.elasticsearch.elasticsearch_service_name}
    port: ${module.elasticsearch.elasticsearch_service_port}
    user: elastic
    usePassword: false
    password: changeme
    # indexPrefix: test
    ## Use existing secret (ignores previous password)
    # existingSecret:
    # existingSecretKey:
    nodesWanOnly: false
    extraEnv: []
    ## ES related env vars to be configured on the concerned components
      # - name: ES_SERVER_URLS
      #   value: http://elasticsearch-master:9200
      # - name: ES_USERNAME
      #   value: elastic
      # - name: ES_INDEX_PREFIX
      #   value: test
    ## ES related cmd line opts to be configured on the concerned components
    cmdlineParams: {}
      # es.server-urls: http://elasticsearch-master:9200
      # es.username: elastic
      # es.index-prefix: test

# Begin: Default values for the various components of Jaeger
# This chart has been based on the Kubernetes integration found in the following repo:
# https://github.com/jaegertracing/jaeger-kubernetes/blob/main/production/jaeger-production-template.yml
#
# This is the jaeger-cassandra-schema Job which sets up the Cassandra schema for
# use by Jaeger
schema:
  annotations: {}
  image: jaegertracing/jaeger-cassandra-schema
  imagePullSecrets: []
  pullPolicy: IfNotPresent
  resources: {}
    # limits:
    #   cpu: 500m
    #   memory: 512Mi
    # requests:
    #   cpu: 256m
    #   memory: 128Mi
  serviceAccount:
    create: true
    # Explicitly mounts the API credentials for the Service Account
    automountServiceAccountToken: true
    name:
  podAnnotations: {}
  podLabels: {}
  securityContext: {}
  podSecurityContext: {}
  ## Deadline for cassandra schema creation job
  activeDeadlineSeconds: 300
  extraEnv: []
    # - name: MODE
    #   value: prod
    # - name: TRACE_TTL
    #   value: "172800"
    # - name: DEPENDENCIES_TTL
    #   value: "0"

# For configurable values of the elasticsearch if provisioned, please see:
# https://github.com/elastic/helm-charts/tree/master/elasticsearch#configuration
elasticsearch: {}

ingester:
  enabled: false

agent:
  podSecurityContext: {}
  securityContext: {}
  enabled: true
  annotations: {}
  image: jaegertracing/jaeger-agent
  # tag: 1.22
  imagePullSecrets: []
  pullPolicy: IfNotPresent
  cmdlineParams: {}
  extraEnv: []
  daemonset:
    useHostPort: false
    updateStrategy:
      type: RollingUpdate
      rollingUpdate:
        maxUnavailable: 1
  service:
    type: ClusterIP
    # zipkinThriftPort :accept zipkin.thrift over compact thrift protocol
    zipkinThriftPort: 5775
    # compactPort: accept jaeger.thrift over compact thrift protocol
    compactPort: 6831
    # binaryPort: accept jaeger.thrift over binary thrift protocol
    binaryPort: 6832
    # samplingPort: (HTTP) serve configs, sampling strategies
    samplingPort: 5778
  resources:
    limits:
      cpu: 500m
      memory: 512Mi
    requests:
      cpu: 256m
      memory: 128Mi
  serviceAccount:
    create: true
    # Explicitly mounts the API credentials for the Service Account
    automountServiceAccountToken: false
    name:
    annotations: {}
%{ if var.node_group_workload_class != "" ~}
  # It's OK to be deployed to the tools pool, too
  tolerations:
    - key: "group.msg.cloud.kubernetes/workload"
      operator: "Equal"
      value: ${var.node_group_workload_class}
      effect: "NoSchedule"
%{ endif ~}
  podAnnotations: {}
  ## Additional pod labels
  ## ref: https://kubernetes.io/docs/concepts/overview/working-with-objects/labels/
  podLabels: {}
  useHostNetwork: false
  dnsPolicy: ClusterFirst
  priorityClassName: ""
  serviceMonitor:
    enabled: true

collector:
  podSecurityContext: {}
  securityContext: {}
  enabled: true
  annotations: {}
  image: jaegertracing/jaeger-collector
  # tag: 1.22
  imagePullSecrets: []
  pullPolicy: IfNotPresent
  dnsPolicy: ClusterFirst
  cmdlineParams: {}
  replicaCount: 1
  autoscaling:
    enabled: false
    minReplicas: 2
    maxReplicas: 10
    # targetCPUUtilizationPercentage: 80
    # targetMemoryUtilizationPercentage: 80
  service:
    annotations: {}
    type: ClusterIP
    grpc:
      port: 14250
    # httpPort: can accept spans directly from clients in jaeger.thrift format
    http:
      port: 14268
    # can accept Zipkin spans in JSON or Thrift
    zipkin: {}
      # port: 9411
      # nodePort:
  ingress:
    enabled: false
  resources:
    limits:
      cpu: 1
      memory: 1Gi
    requests:
      cpu: 500m
      memory: 512Mi
  serviceAccount:
    create: true
    # Explicitly mounts the API credentials for the Service Account
    automountServiceAccountToken: false
    name:
    annotations: {}
%{ if var.node_group_workload_class != "" ~}
  # It's OK to be deployed to the tools pool, too
  tolerations:
    - key: "group.msg.cloud.kubernetes/workload"
      operator: "Equal"
      value: ${var.node_group_workload_class}
      effect: "NoSchedule"
%{ endif ~}
%{ if var.node_group_workload_class != "" ~}
  affinity:
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
  podAnnotations: {}
  ## Additional pod labels
  ## ref: https://kubernetes.io/docs/concepts/overview/working-with-objects/labels/
  podLabels: {}
  extraSecretMounts: []
  # - name: jaeger-tls
  #   mountPath: /tls
  #   subPath: ""
  #   secretName: jaeger-tls
  #   readOnly: true
  extraConfigmapMounts: []
  # - name: jaeger-config
  #   mountPath: /config
  #   subPath: ""
  #   configMap: jaeger-config
  #   readOnly: true
  # samplingConfig: |-
  #   {
  #     "service_strategies": [
  #       {
  #         "service": "foo",
  #         "type": "probabilistic",
  #         "param": 0.8,
  #         "operation_strategies": [
  #           {
  #             "operation": "op1",
  #             "type": "probabilistic",
  #             "param": 0.2
  #           },
  #           {
  #             "operation": "op2",
  #             "type": "probabilistic",
  #             "param": 0.4
  #           }
  #         ]
  #       },
  #       {
  #         "service": "bar",
  #         "type": "ratelimiting",
  #         "param": 5
  #       }
  #     ],
  #     "default_strategy": {
  #       "type": "probabilistic",
  #       "param": 1
  #     }
  #   }
  priorityClassName: ""
  serviceMonitor:
    enabled: true

query:
  enabled: true
  oAuthSidecar:
    enabled: false
    image: quay.io/oauth2-proxy/oauth2-proxy:v7.1.0
    pullPolicy: IfNotPresent
    containerPort: 4180
    args: []
    extraEnv: []
    extraConfigmapMounts: []
    extraSecretMounts: []
  # config: |-
  #   provider = "oidc"
  #   https_address = ":4180"
  #   upstreams = ["http://localhost:16686"]
  #   redirect_url = "https://jaeger-svc-domain/oauth2/callback"
  #   client_id = "jaeger-query"
  #   oidc_issuer_url = "https://keycloak-svc-domain/auth/realms/Default"
  #   cookie_secure = "true"
  #   email_domains = "*"
  #   oidc_groups_claim = "groups"
  #   user_id_claim = "preferred_username"
  #   skip_provider_button = "true"
  podSecurityContext: {}
  securityContext: {}
  agentSidecar:
    enabled: true
#    resources:
#      limits:
#        cpu: 500m
#        memory: 512Mi
#      requests:
#        cpu: 256m
#        memory: 128Mi
  annotations: {}
  image: jaegertracing/jaeger-query
  # tag: 1.22
  imagePullSecrets: []
  pullPolicy: IfNotPresent
  dnsPolicy: ClusterFirst
  cmdlineParams: {}
  extraEnv: []
  replicaCount: 1
  service:
    annotations: {}
    type: ClusterIP
    port: 80
    # Specify a custom target port (e.g. port of auth proxy)
    # targetPort: 8080
  basePath: /jaeger
  ingress:
    enabled: true
    ingressClassName: nginx
    annotations: {}
      # nginx.ingress.kubernetes.io/rewrite-target: /$2
    hosts:
      - ${var.ingress_host_name}
    health:
      exposed: false
  resources:
    limits:
      cpu: 500m
      memory: 512Mi
    requests:
      cpu: 256m
      memory: 128Mi
  serviceAccount:
    create: true
    # Explicitly mounts the API credentials for the Service Account
    automountServiceAccountToken: false
    name:
    annotations: {}
  nodeSelector: {}
%{ if var.node_group_workload_class != "" ~}
  # It's OK to be deployed to the tools pool, too
  tolerations:
    - key: "group.msg.cloud.kubernetes/workload"
      operator: "Equal"
      value: ${var.node_group_workload_class}
      effect: "NoSchedule"
%{ endif ~}
%{ if var.node_group_workload_class != "" ~}
  affinity:
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
  podAnnotations: {}
  ## Additional pod labels
  ## ref: https://kubernetes.io/docs/concepts/overview/working-with-objects/labels/
  podLabels: {}
  extraConfigmapMounts: []
  # - name: jaeger-config
  #   mountPath: /config
  #   subPath: ""
  #   configMap: jaeger-config
  #   readOnly: true
  extraVolumes: []
  sidecars: []
  ##   - name: your-image-name
  ##     image: your-image
  ##     ports:
  ##       - name: portname
  ##         containerPort: 1234
  priorityClassName: ""
  serviceMonitor:
    enabled: true
    additionalLabels: {}
  # config: |-
  #   {
  #     "dependencies": {
  #       "dagMaxNumServices": 200,
  #       "menuEnabled": true
  #     },
  #     "archiveEnabled": true,
  #     "tracking": {
  #       "gaID": "UA-000000-2",
  #       "trackErrors": true
  #     }
  #   }

esIndexCleaner:
  enabled: true
  securityContext:
    runAsUser: 1000
  podSecurityContext:
    runAsUser: 1000
  annotations: {}
  image: jaegertracing/jaeger-es-index-cleaner
  imagePullSecrets: []
  pullPolicy: IfNotPresent
  cmdlineParams: {}
  extraEnv: []
    # - name: ROLLOVER
    #   value: 'true'
  schedule: "55 23 * * *"
  successfulJobsHistoryLimit: 3
  failedJobsHistoryLimit: 3
  concurrencyPolicy: Forbid
  resources:
    limits:
      cpu: 500m
      memory: 512Mi
    requests:
      cpu: 256m
      memory: 128Mi
  numberOfDays: 7
  serviceAccount:
    create: true
    # Explicitly mounts the API credentials for the Service Account
    automountServiceAccountToken: false
    name:
  nodeSelector: {}
%{ if var.node_group_workload_class != "" ~}
  # It's OK to be deployed to the tools pool, too
  tolerations:
    - key: "group.msg.cloud.kubernetes/workload"
      operator: "Equal"
      value: ${var.node_group_workload_class}
      effect: "NoSchedule"
%{ endif ~}
%{ if var.node_group_workload_class != "" ~}
  affinity:
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
  extraSecretMounts: []
  extraConfigmapMounts: []
  podAnnotations: {}
  ## Additional pod labels
  ## ref: https://kubernetes.io/docs/concepts/overview/working-with-objects/labels/
  podLabels: {}

esRollover:
  enabled: true
  securityContext: {}
  podSecurityContext:
    runAsUser: 1000
  annotations: {}
  image: jaegertracing/jaeger-es-rollover
  imagePullSecrets: []
  tag: latest
  pullPolicy: Always
  cmdlineParams: {}
  extraEnv:
    - name: CONDITIONS
      value: '{"max_age": "1d"}'
  schedule: "10 0 * * *"
  successfulJobsHistoryLimit: 3
  failedJobsHistoryLimit: 3
  concurrencyPolicy: Forbid
  resources:
    limits:
      cpu: 500m
      memory: 512Mi
    requests:
      cpu: 256m
      memory: 128Mi
  serviceAccount:
    create: true
    # Explicitly mounts the API credentials for the Service Account
    automountServiceAccountToken: false
    name:
  nodeSelector: {}
%{ if var.node_group_workload_class != "" ~}
  # It's OK to be deployed to the tools pool, too
  tolerations:
    - key: "group.msg.cloud.kubernetes/workload"
      operator: "Equal"
      value: ${var.node_group_workload_class}
      effect: "NoSchedule"
%{ endif ~}
%{ if var.node_group_workload_class != "" ~}
  affinity:
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
  extraSecretMounts: []
  extraConfigmapMounts: []
  podAnnotations: {}
  ## Additional pod labels
  ## ref: https://kubernetes.io/docs/concepts/overview/working-with-objects/labels/
  podLabels: {}
  initHook:
    extraEnv:
      - name: SHARDS
        value: "3"
    annotations: {}
    podAnnotations: {}
    podLabels: {}
    ttlSecondsAfterFinished: 120

esLookback:
  enabled: false
  securityContext: {}
  podSecurityContext:
    runAsUser: 1000
  annotations: {}
  image: jaegertracing/jaeger-es-rollover
  imagePullSecrets: []
  tag: latest
  pullPolicy: Always
  cmdlineParams: {}
  extraEnv:
    - name: UNIT
      value: days
    - name: UNIT_COUNT
      value: '7'
  schedule: '5 0 * * *'
  successfulJobsHistoryLimit: 3
  failedJobsHistoryLimit: 3
  concurrencyPolicy: Forbid
  resources: {}
    # limits:
    #   cpu: 500m
    #   memory: 512Mi
    # requests:
    #   cpu: 256m
    #   memory: 128Mi
  serviceAccount:
    create: true
    # Explicitly mounts the API credentials for the Service Account
    automountServiceAccountToken: false
    name:
  nodeSelector: {}
  tolerations: []
  affinity: {}
  extraSecretMounts: []
  extraConfigmapMounts: []
  podAnnotations: {}
  ## Additional pod labels
  ## ref: https://kubernetes.io/docs/concepts/overview/working-with-objects/labels/
  podLabels: {}
# End: Default values for the various components of Jaeger

hotrod:
  enabled: false
  podSecurityContext: {}
  securityContext: {}
  replicaCount: 1
  image:
    repository: jaegertracing/example-hotrod
    pullPolicy: Always
    pullSecrets: []
  service:
    annotations: {}
    name: hotrod
    type: ClusterIP
    # List of IP ranges that are allowed to access the load balancer (if supported)
    loadBalancerSourceRanges: []
    port: 80
  ingress:
    enabled: false
    # For Kubernetes >= 1.18 you should specify the ingress-controller via the field ingressClassName
    # See https://kubernetes.io/blog/2020/04/02/improvements-to-the-ingress-api-in-kubernetes-1.18/#specifying-the-class-of-an-ingress
    # ingressClassName: nginx
    # Used to create Ingress record (should be used with service.type: ClusterIP).
    hosts:
      - chart-example.local
    annotations: {}
      # kubernetes.io/ingress.class: nginx
      # kubernetes.io/tls-acme: "true"
    tls:
      # Secrets must be manually created in the namespace.
      # - secretName: chart-example-tls
      #   hosts:
      #     - chart-example.local
  resources: {}
    # We usually recommend not to specify default resources and to leave this as a conscious
    # choice for the user. This also increases chances charts run on environments with little
    # resources, such as Minikube. If you do want to specify resources, uncomment the following
    # lines, adjust them as necessary, and remove the curly braces after 'resources:'.
    # limits:
    #   cpu: 100m
    #   memory: 128Mi
    # requests:
    #   cpu: 100m
    #   memory: 128Mi
  serviceAccount:
    create: true
    # Explicitly mounts the API credentials for the Service Account
    automountServiceAccountToken: false
    name:
  nodeSelector: {}
  tolerations: []
  affinity: {}
  tracing:
    host: null
    port: 6831

# Array with extra yaml objects to install alongside the chart. Values are evaluated as a template.
extraObjects: []
EOT
}

resource helm_release jaeger {
  chart = "jaeger"
  version = "0.51.5"
  name = var.helm_release_name
  dependency_update = true
  atomic = true
  cleanup_on_fail = true
  namespace = kubernetes_namespace.namespace.metadata[0].name
  repository = "https://jaegertracing.github.io/helm-charts"
  values = [ local.helm_values ]
}