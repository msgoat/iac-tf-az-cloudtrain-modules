locals {
  actual_replica_count = var.ensure_high_availability && var.replica_count < 2 ? 2 : var.replica_count
  helm_chart_name      = "external-dns"
  helm_chart_values    = <<EOT
# -- Labels to add to all chart resources.
commonLabels: {}

serviceAccount:
  create: true
  # -- Annotations to add to the service account.
  annotations:
    azure.workload.identity/client-id: ${azurerm_user_assigned_identity.external_dns.client_id}

service:
  # -- Service annotations.
  annotations: {}
  # -- Service HTTP port.
  port: 7979

rbac:
  # -- If `true`, create a `ClusterRole` & `ClusterRoleBinding` with access to the Kubernetes API.
  create: true

# -- Labels to add to the `Pod`.
podLabels:
  azure.workload.identity/use: "true"

# -- Annotations to add to the `Pod`.
podAnnotations: {}

# -- If `true`, the `Pod` will have [process namespace sharing](https://kubernetes.io/docs/tasks/configure-pod-container/share-process-namespace/) enabled.
shareProcessNamespace: false

# -- [Pod security context](https://kubernetes.io/docs/reference/generated/kubernetes-api/v1.22/#podsecuritycontext-v1-core), this supports full customisation.
# @default -- See _values.yaml_
podSecurityContext:
  runAsNonRoot: true
  fsGroup: 65534
  seccompProfile:
    type: RuntimeDefault

# -- (string) Priority class name for the `Pod`.
priorityClassName:

# -- (int) Termination grace period for the `Pod` in seconds.
terminationGracePeriodSeconds:

# -- (string) [DNS policy](https://kubernetes.io/docs/concepts/services-networking/dns-pod-service/#pod-s-dns-policy) for the pod, if not set the default will be used.
dnsPolicy:

# -- [Init containers](https://kubernetes.io/docs/concepts/workloads/pods/init-containers/) to add to the `Pod` definition.
initContainers: []

# -- [Security context](https://kubernetes.io/docs/tasks/configure-pod-container/security-context/#set-the-security-context-for-a-container) for the `external-dns` container.
# @default -- See _values.yaml_
securityContext:
  privileged: false
  allowPrivilegeEscalation: false
  readOnlyRootFilesystem: true
  runAsNonRoot: true
  runAsUser: 65532
  runAsGroup: 65532
  capabilities:
    drop: ["ALL"]

# -- [Environment variables](https://kubernetes.io/docs/tasks/inject-data-application/define-environment-variable-container/) for the `external-dns` container.
env: []

# -- [Liveness probe](https://kubernetes.io/docs/tasks/configure-pod-container/configure-liveness-readiness-startup-probes/) configuration for the `external-dns` container.
# @default -- See _values.yaml_
livenessProbe:
  httpGet:
    path: /healthz
    port: http
  initialDelaySeconds: 10
  periodSeconds: 10
  timeoutSeconds: 5
  failureThreshold: 2
  successThreshold: 1

# -- [Readiness probe](https://kubernetes.io/docs/tasks/configure-pod-container/configure-liveness-readiness-startup-probes/) configuration for the `external-dns` container.
# @default -- See _values.yaml_
readinessProbe:
  httpGet:
    path: /healthz
    port: http
  initialDelaySeconds: 5
  periodSeconds: 10
  timeoutSeconds: 5
  failureThreshold: 6
  successThreshold: 1

# -- Extra [volumes](https://kubernetes.io/docs/concepts/storage/volumes/) for the `Pod`.
extraVolumes: []

# -- Extra [volume mounts](https://kubernetes.io/docs/concepts/storage/volumes/) for the `external-dns` container.
extraVolumeMounts: []

# -- [Resources](https://kubernetes.io/docs/concepts/configuration/manage-resources-containers/) for the `external-dns` container.
resources: {}

# -- Node labels to match for `Pod` [scheduling](https://kubernetes.io/docs/concepts/scheduling-eviction/assign-pod-node/).
nodeSelector: {}

# -- Affinity settings for `Pod` [scheduling](https://kubernetes.io/docs/concepts/scheduling-eviction/assign-pod-node/). If an explicit label selector is not provided for pod affinity or pod anti-affinity one will be created from the pod selector labels.
affinity: {}

# -- Topology spread constraints for `Pod` [scheduling](https://kubernetes.io/docs/concepts/scheduling-eviction/assign-pod-node/). If an explicit label selector is not provided one will be created from the pod selector labels.
%{if var.ensure_high_availability~}
topologySpreadConstraints:
- labelSelector:
    matchLabels:
      app.kubernetes.io/name: ${local.helm_chart_name}
      app.kubernetes.io/instance: ${var.helm_release_name}
  topologyKey: topology.kubernetes.io/zone
  maxSkew: 1
  whenUnsatisfiable: ScheduleAnyway
- labelSelector:
    matchLabels:
      app.kubernetes.io/name: ${local.helm_chart_name}
      app.kubernetes.io/instance: ${var.helm_release_name}
  topologyKey: kubernetes.io/hostname
  maxSkew: 1
  whenUnsatisfiable: ScheduleAnyway
%{else~}
topologySpreadConstraints: []
%{endif~}

# -- Node taints which will be tolerated for `Pod` [scheduling](https://kubernetes.io/docs/concepts/scheduling-eviction/assign-pod-node/).
tolerations: []

serviceMonitor:
  # -- If `true`, create a `ServiceMonitor` resource to support the _Prometheus Operator_.
  enabled: false
  # -- Additional labels for the `ServiceMonitor`.
  additionalLabels: {}
  # -- Annotations to add to the `ServiceMonitor`.
  annotations: {}
  # -- (string) If set create the `ServiceMonitor` in an alternate namespace.
  namespace:
  # -- (string) If set override the _Prometheus_ default interval.
  interval:
  # -- (string) If set override the _Prometheus_ default scrape timeout.
  scrapeTimeout:
  # -- (string) If set overrides the _Prometheus_ default scheme.
  scheme:
  # -- Configure the `ServiceMonitor` [TLS config](https://github.com/coreos/prometheus-operator/blob/master/Documentation/api.md#tlsconfig).
  tlsConfig: {}
  # -- (string) Provide a bearer token file for the `ServiceMonitor`.
  bearerTokenFile:
  # -- [Relabel configs](https://prometheus.io/docs/prometheus/latest/configuration/configuration/#relabel_config) to apply to samples before ingestion.
  relabelings: []
  # -- [Metric relabel configs](https://prometheus.io/docs/prometheus/latest/configuration/configuration/#metric_relabel_configs) to apply to samples before ingestion.
  metricRelabelings: []
  # -- Provide target labels for the `ServiceMonitor`.
  targetLabels: []

# -- Log level.
logLevel: info

# -- Log format.
logFormat: json

# -- Interval for DNS updates.
interval: 1m

# -- If `true`, triggers run loop on create/update/delete events in addition of regular interval.
triggerLoopOnEvent: false

# -- if `true`, _ExternalDNS_ will run in a namespaced scope (`Role`` and `Rolebinding`` will be namespaced too).
namespaced: false

# -- _Kubernetes_ resources to monitor for DNS entries.
sources:
  - ingress

# -- How DNS records are synchronized between sources and providers; available values are `sync` & `upsert-only`.
policy: upsert-only

# -- Specify the registry for storing ownership and labels.
# Valid values are `txt`, `aws-sd`, `dynamodb` & `noop`.
registry: txt
# -- (string) Specify an identifier for this instance of _ExternalDNS_ wWhen using a registry other than `noop`.
txtOwnerId:
# -- (string) Specify a prefix for the domain names of TXT records created for the `txt` registry.
# Mutually exclusive with `txtSuffix`.
txtPrefix:
# -- (string) Specify a suffix for the domain names of TXT records created for the `txt` registry.
# Mutually exclusive with `txtPrefix`.
txtSuffix:

## - Limit possible target zones by domain suffixes.
domainFilters: []

provider:
  # -- _ExternalDNS_ provider name; for the available providers and how to configure them see [README](https://github.com/kubernetes-sigs/external-dns/blob/master/charts/external-dns/README.md#providers).
  name: azure
  webhook:
    image:
      # -- (string) Image repository for the `webhook` container.
      repository:
      # -- (string) Image tag for the `webhook` container.
      tag:
      # -- Image pull policy for the `webhook` container.
      pullPolicy: IfNotPresent
    # -- [Environment variables](https://kubernetes.io/docs/tasks/inject-data-application/define-environment-variable-container/) for the `webhook` container.
    env: []
    # -- Extra arguments to provide for the `webhook` container.
    args: []
    # -- Extra [volume mounts](https://kubernetes.io/docs/concepts/storage/volumes/) for the `webhook` container.
    extraVolumeMounts: []
    # -- [Resources](https://kubernetes.io/docs/concepts/configuration/manage-resources-containers/) for the `webhook` container.
    resources: {}
    # -- [Pod security context](https://kubernetes.io/docs/tasks/configure-pod-container/security-context/#set-the-security-context-for-a-container) for the `webhook` container.
    # @default -- See _values.yaml_
    securityContext: {}
    # -- [Liveness probe](https://kubernetes.io/docs/tasks/configure-pod-container/configure-liveness-readiness-startup-probes/) configuration for the `external-dns` container.
    # @default -- See _values.yaml_
    livenessProbe:
      httpGet:
        path: /healthz
        port: http-webhook
      initialDelaySeconds: 10
      periodSeconds: 10
      timeoutSeconds: 5
      failureThreshold: 2
      successThreshold: 1
    # -- [Readiness probe](https://kubernetes.io/docs/tasks/configure-pod-container/configure-liveness-readiness-startup-probes/) configuration for the `webhook` container.
    # @default -- See _values.yaml_
    readinessProbe:
      httpGet:
        path: /healthz
        port: http-webhook
      initialDelaySeconds: 5
      periodSeconds: 10
      timeoutSeconds: 5
      failureThreshold: 6
      successThreshold: 1
    # -- Optional [Service Monitor](https://prometheus-operator.dev/docs/operator/design/#servicemonitor) configuration for the `webhook` container.
    # @default -- See _values.yaml_
    serviceMonitor:
      interval:
      scheme:
      tlsConfig: {}
      bearerTokenFile:
      scrapeTimeout:
      metricRelabelings: []
      relabelings: []

# -- Extra arguments to provide to _ExternalDNS_.
extraArgs: []

# -- Should not be required anymore but pod does not start without it
secretConfiguration:
  enabled: true
  mountPath: "/etc/kubernetes/"
  data:
    azure.json: |
      {
        "subscriptionId": "${local.public_dns_zone_subscription_id}",
        "resourceGroup": "${local.public_dns_zone_rg_name}",
        "useWorkloadIdentityExtension": true
      }
EOT
}

# deploys ExternalDNS
resource "helm_release" "external_dns" {
  name              = var.helm_release_name
  chart             = local.helm_chart_name
  version           = var.helm_chart_version
  namespace         = var.kubernetes_namespace_owned ? kubernetes_namespace.external_dns[0].metadata[0].name : var.kubernetes_namespace_name
  create_namespace  = false
  dependency_update = true
  repository        = "https://kubernetes-sigs.github.io/external-dns/"
  atomic            = true
  cleanup_on_fail   = true
  values            = [local.helm_chart_values]
}
