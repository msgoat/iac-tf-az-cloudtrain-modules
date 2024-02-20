locals {
  actual_replica_count = var.ensure_high_availability ? 2 : 1
  helm_chart_name      = "ingress-nginx"
  # render helm chart values since direct passing of values does not work in all cases
  helm_chart_values = <<EOT
## nginx configuration
## Ref: https://github.com/kubernetes/ingress-nginx/blob/main/docs/user-guide/nginx-configuration/index.md
controller:
  name: controller
  enableAnnotationValidations: false
  # -- Configures the ports that the nginx-controller listens on
  containerPort:
    http: 80
    https: 443
  # -- Will add custom configuration options to Nginx https://kubernetes.github.io/ingress-nginx/user-guide/nginx-configuration/configmap/
  config: {}
  # -- Annotations to be added to the controller config configuration configmap.
  configAnnotations: {}
  # -- Will add custom headers before sending traffic to backends according to https://github.com/kubernetes/ingress-nginx/tree/main/docs/examples/customization/custom-headers
  proxySetHeaders: {}
  # -- Will add custom headers before sending response traffic to the client according to: https://kubernetes.github.io/ingress-nginx/user-guide/nginx-configuration/configmap/#add-headers
  addHeaders: {}
  # -- Process IngressClass per name (additionally as per spec.controller).
  ingressClassByName: false
  # -- This configuration enables Topology Aware Routing feature, used together with service annotation service.kubernetes.io/topology-mode="auto"
  # Defaults to false
  enableTopologyAwareRouting: false
  ingressClassResource:
    name: ${var.kubernetes_ingress_class_name}
    enabled: true
    default: ${var.kubernetes_default_ingress_class}
    controllerValue: "k8s.io/ingress-nginx"
  ingressClass: ${var.kubernetes_ingress_class_name}
  # -- Labels to add to the pod container metadata
  podLabels: {}
  podSecurityContext: {}
  sysctls: {}
  containerSecurityContext: {}
  extraArgs: {}
  ## extraArgs:
  ##   default-ssl-certificate: "<namespace>/<secret_name>"
  ##   time-buckets: "0.005,0.01,0.025,0.05,0.1,0.25,0.5,1,2.5,5,10"
  ##   length-buckets: "10,20,30,40,50,60,70,80,90,100"
  ##   size-buckets: "10,100,1000,10000,100000,1e+06,1e+07"
  extraEnvs: []
  annotations: {}
  labels: {}
%{if var.node_group_workload_class != ""~}
  # It's OK to be deployed to the tools pool, too
  tolerations:
    - key: "group.msg.cloud.kubernetes/workload"
      operator: "Equal"
      value: ${var.node_group_workload_class}
      effect: "NoSchedule"
%{endif~}
  affinity:
%{if var.node_group_workload_class != ""~}
    # Encourages deployment to the tools pool
    nodeAffinity:
      requiredDuringSchedulingIgnoredDuringExecution:
        nodeSelectorTerms:
          - matchExpressions:
              - key: "group.msg.cloud.kubernetes/workload"
                operator: In
                values:
                  - ${var.node_group_workload_class}
%{endif~}
%{if var.ensure_high_availability~}
     # Avoid running replicas on the same node
    podAntiAffinity:
      preferredDuringSchedulingIgnoredDuringExecution:
        - weight: 100
          podAffinityTerm:
            labelSelector:
              matchExpressions:
              - key: app.kubernetes.io/name
                operator: In
                values:
                - ingress-nginx
              - key: app.kubernetes.io/instance
                operator: In
                values:
                - ingress-nginx
              - key: app.kubernetes.io/component
                operator: In
                values:
                - controller
            topologyKey: kubernetes.io/hostname
%{endif~}

  # -- Topology spread constraints rely on node labels to identify the topology domain(s) that each Node is in.
  ## Ref: https://kubernetes.io/docs/concepts/workloads/pods/pod-topology-spread-constraints/
  ##
  topologySpreadConstraints: []
  # - labelSelector:
  #     matchLabels:
  #       app.kubernetes.io/name: '{{ include "ingress-nginx.name" . }}'
  #       app.kubernetes.io/instance: '{{ .Release.Name }}'
  #       app.kubernetes.io/component: controller
  #   topologyKey: topology.kubernetes.io/zone
  #   maxSkew: 1
  #   whenUnsatisfiable: ScheduleAnyway
  # - labelSelector:
  #     matchLabels:
  #       app.kubernetes.io/name: '{{ include "ingress-nginx.name" . }}'
  #       app.kubernetes.io/instance: '{{ .Release.Name }}'
  #       app.kubernetes.io/component: controller
  #   topologyKey: kubernetes.io/hostname
  #   maxSkew: 1
  #   whenUnsatisfiable: ScheduleAnyway

  # -- `terminationGracePeriodSeconds` to avoid killing pods before we are ready
  ## wait up to five minutes for the drain of connections
  ##
  terminationGracePeriodSeconds: 300
  # -- Node labels for controller pod assignment
  startupProbe:
    httpGet:
      # should match container.healthCheckPath
      path: "/healthz"
      port: 10254
      scheme: HTTP
    initialDelaySeconds: 5
    periodSeconds: 5
    timeoutSeconds: 2
    successThreshold: 1
    failureThreshold: 5
  livenessProbe:
    httpGet:
      # should match container.healthCheckPath
      path: "/healthz"
      port: 10254
      scheme: HTTP
    initialDelaySeconds: 10
    periodSeconds: 10
    timeoutSeconds: 1
    successThreshold: 1
    failureThreshold: 5
  readinessProbe:
    httpGet:
      # should match container.healthCheckPath
      path: "/healthz"
      port: 10254
      scheme: HTTP
    initialDelaySeconds: 10
    periodSeconds: 10
    timeoutSeconds: 1
    successThreshold: 1
    failureThreshold: 3
  # -- Path of the health check endpoint. All requests received on the port defined by
  # the healthz-port parameter are forwarded internally to this path.
  healthCheckPath: "/healthz"
  # -- Annotations to be added to controller pods
  ##
  podAnnotations: {}
  replicaCount: ${local.actual_replica_count}
  # -- Minimum available pods set in PodDisruptionBudget.
  # Define either 'minAvailable' or 'maxUnavailable', never both.
  minAvailable: 1
  # -- Maximum unavailable pods set in PodDisruptionBudget. If set, 'minAvailable' is ignored.
  # maxUnavailable: 1

  ## Define requests resources to avoid probe issues due to CPU utilization in busy nodes
  ## ref: https://github.com/kubernetes/ingress-nginx/issues/4735#issuecomment-551204903
  ## Ideally, there should be no limits.
  ## https://engineering.indeedblog.com/blog/2019/12/cpu-throttling-regression-fix/
  resources:
    ##  limits:
    ##    cpu: 100m
    ##    memory: 90Mi
    requests:
      cpu: 100m
      memory: 90Mi
  # -- Enable mimalloc as a drop-in replacement for malloc.
  service:
    # -- Enable controller services or not. This does not influence the creation of either the admission webhook or the metrics service.
    enabled: true
    external:
      # -- Enable the external controller service or not. Useful for internal-only deployments.
      enabled: true
    # -- Annotations to be added to the external controller service. See `controller.service.internal.annotations` for annotations to be added to the internal controller service.
    annotations: {}
    # -- Labels to be added to both controller services.
    labels: {}
    # -- Type of the external controller service.
    # Ref: https://kubernetes.io/docs/concepts/services-networking/service/#publishing-services-service-types
%{if var.agic_enabled~}
    type: ClusterIP
%{else~}
    type: LoadBalancer
%{endif~}
    # -- External traffic policy of the external controller service. Set to "Local" to preserve source IP on providers supporting it.
    # Ref: https://kubernetes.io/docs/tasks/access-application-cluster/create-external-load-balancer/#preserving-the-client-source-ip
    externalTrafficPolicy: ""
    # -- Session affinity of the external controller service. Must be either "None" or "ClientIP" if set. Defaults to "None".
    # Ref: https://kubernetes.io/docs/reference/networking/virtual-ips/#session-affinity
    sessionAffinity: ""
    # -- Specifies the health check node port (numeric port number) for the external controller service.
    # If not specified, the service controller allocates a port from your cluster's node port range.
    # Ref: https://kubernetes.io/docs/tasks/access-application-cluster/create-external-load-balancer/#preserving-the-client-source-ip
    # healthCheckNodePort: 0
    # -- Represents the dual-stack capabilities of the external controller service. Possible values are SingleStack, PreferDualStack or RequireDualStack.
    # Fields `ipFamilies` and `clusterIP` depend on the value of this field.
    # Ref: https://kubernetes.io/docs/concepts/services-networking/dual-stack/#services
    ipFamilyPolicy: SingleStack
    # -- List of IP families (e.g. IPv4, IPv6) assigned to the external controller service. This field is usually assigned automatically based on cluster configuration and the `ipFamilyPolicy` field.
    # Ref: https://kubernetes.io/docs/concepts/services-networking/dual-stack/#services
    ipFamilies:
      - IPv4
    # -- Enable the HTTP listener on both controller services or not.
    enableHttp: true
    # -- Enable the HTTPS listener on both controller services or not.
    enableHttps: true
    ports:
      # -- Port the external HTTP listener is published with.
      http: 80
      # -- Port the external HTTPS listener is published with.
      https: 443
    targetPorts:
      # -- Port of the ingress controller the external HTTP listener is mapped to.
      http: http
      # -- Port of the ingress controller the external HTTPS listener is mapped to.
      https: https
    # -- Declare the app protocol of the external HTTP and HTTPS listeners or not. Supersedes provider-specific annotations for declaring the backend protocol.
    # Ref: https://kubernetes.io/docs/concepts/services-networking/service/#application-protocol
    appProtocol: true
  # shareProcessNamespace enables process namespace sharing within the pod.
  # This can be used for example to signal log rotation using `kill -USR1` from a sidecar.
  shareProcessNamespace: false
  admissionWebhooks:
    name: admission
    annotations: {}
    # ignore-check.kube-linter.io/no-read-only-rootfs: "This deployment needs write access to root filesystem".

    ## Additional annotations to the admission webhooks.
    ## These annotations will be added to the ValidatingWebhookConfiguration and
    ## the Jobs Spec of the admission webhooks.
    enabled: true
    # -- Additional environment variables to set
    extraEnvs: []
    # extraEnvs:
    #   - name: FOO
    #     valueFrom:
    #       secretKeyRef:
    #         key: FOO
    #         name: secret-resource
    # -- Admission Webhook failure policy to use
    failurePolicy: Fail
    # timeoutSeconds: 10
    port: 8443
    certificate: "/usr/local/certificates/cert"
    key: "/usr/local/certificates/key"
    namespaceSelector: {}
    objectSelector: {}
    # -- Labels to be added to admission webhooks
    labels: {}
    # -- Use an existing PSP instead of creating one
    existingPsp: ""
    service:
      annotations: {}
      # clusterIP: ""
      externalIPs: []
      # loadBalancerIP: ""
      loadBalancerSourceRanges: []
      servicePort: 443
      type: ClusterIP
    createSecretJob:
      name: create
      # -- Security context for secret creation containers
      securityContext:
        runAsNonRoot: true
        runAsUser: 65532
        allowPrivilegeEscalation: false
        seccompProfile:
          type: RuntimeDefault
        capabilities:
          drop:
            - ALL
        readOnlyRootFilesystem: true
      resources: {}
      # limits:
      #   cpu: 10m
      #   memory: 20Mi
      # requests:
      #   cpu: 10m
      #   memory: 20Mi
    patchWebhookJob:
      name: patch
      # -- Security context for webhook patch containers
      securityContext:
        runAsNonRoot: true
        runAsUser: 65532
        allowPrivilegeEscalation: false
        seccompProfile:
          type: RuntimeDefault
        capabilities:
          drop:
            - ALL
        readOnlyRootFilesystem: true
      resources: {}
    patch:
      enabled: true
      # -- Provide a priority class name to the webhook patching job
      ##
      priorityClassName: ""
      podAnnotations: {}
      # NetworkPolicy for webhook patch
      networkPolicy:
        # -- Enable 'networkPolicy' or not
        enabled: false
      nodeSelector:
        kubernetes.io/os: linux
      tolerations: []
      # -- Labels to be added to patch job resources
      labels: {}
      # -- Security context for secret creation & webhook patch pods
      securityContext: {}
%{if var.cert_manager_enabled~}
    # Use certmanager to generate webhook certs
    certManager:
      enabled: true
      # self-signed root certificate
      rootCert:
        # default to be 5y
        duration: ""
      admissionCert:
        # default to be 1y
        duration: ""
        issuerRef:
          name: "${var.cert_manager_issuer_name}"
          kind: "ClusterIssuer"
%{endif~}
defaultBackend:
  enabled: ${var.nginx_default_backend_enabled}
  name: defaultbackend
  serviceAccount:
    create: true
    automountServiceAccountToken: false
  replicaCount: ${local.actual_replica_count}
  minAvailable: 1
  resources: {}
  # limits:
  #   cpu: 10m
  #   memory: 20Mi
  # requests:
  #   cpu: 10m
  #   memory: 20Mi
EOT
}

resource "helm_release" "nginx" {
  chart             = local.helm_chart_name
  version           = var.helm_chart_version
  name              = var.helm_release_name
  dependency_update = true
  atomic            = true
  cleanup_on_fail   = true
  namespace         = var.kubernetes_namespace_owned ? kubernetes_namespace.nginx[0].metadata[0].name : var.kubernetes_namespace_name
  create_namespace  = false
  repository        = "https://kubernetes.github.io/ingress-nginx"
  values            = [local.helm_chart_values]
  wait              = true
}
