locals {
  jaeger_operator_values = <<EOT
# Default values for jaeger-operator.
# This is a YAML-formatted file.
# Declare variables to be passed into your templates.

certs:
  issuer:
    create: true
    name: ""
  certificate:
    create: true
    namespace: ""
    secretName: ""

webhooks:
  mutatingWebhook:
    create: true
  validatingWebhook:
    create: true
  port: 9443
  service:
    annotations: {}
    create: true
    name: ""

jaeger:
  # Specifies whether Jaeger instance should be created
  create: true
  spec:
    strategy: production
    agent:
      strategy: DaemonSet
    collector:
      maxReplicas: 2
      resources:
        limits:
          cpu: 100m
          memory: 128Mi
    storage:
      type: elasticsearch
      options:
        es:
          server-urls: "https://${local.elasticsearch_service_name}:${local.elasticsearch_service_port}"
          index-prefix: jaeger
          tls:
            ca: /es/certificates/ca.crt
      secretName: ${local.elasticsearch_certificates_k8s_secret_name}
    volumeMounts:
      - name: certificates
        mountPath: /es/certificates/
        readOnly: true
    volumes:
      - name: certificates
        secret:
          secretName: ${local.elasticsearch_certificates_k8s_secret_name}
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

rbac:
  # Specifies whether RBAC resources should be created
  create: true
  pspEnabled: false
  clusterRole: true

service:
  type: ClusterIP
  # Specify a specific node port when type is NodePort
  # nodePort: 32500
  # Annotations for service
  annotations: {}

serviceAccount:
  # Specifies whether a ServiceAccount should be created
  create: true
  # The name of the ServiceAccount to use.
  # If not set and create is true, a name is generated using the fullname template
  name:
  # Annotations for serviceAccount
  annotations: {}

# Specifies extra environment variables passed to the operator:
extraEnv: []
  # Specifies log-level for the operator:
  # - name: LOG-LEVEL
  #   value: debug

serviceExtraLabels: {}
  # Specifies extra labels for the operator-metric service:
  # foo: bar

extraLabels: {}
  # Specifies extra labels for the operator deployment:
  # foo: bar

resources: {}
  # limits:
  #  cpu: 100m
  #  memory: 128Mi
  # requests:
  #  cpu: 100m
  #  memory: 128Mi

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

securityContext: {}

priorityClassName:

# Specifies weather host network should be used
hostNetwork: false

metricsPort: 8383
EOT
}

resource helm_release jaeger-operator {
  chart = "jaeger-operator"
  version = "2.39.0"
  name = "jaeger-operator"
  dependency_update = true
  atomic = true
  cleanup_on_fail = true
  namespace = kubernetes_namespace.namespace.metadata[0].name
  repository = "https://jaegertracing.github.io/helm-charts"
  values = [ local.jaeger_operator_values ]
}