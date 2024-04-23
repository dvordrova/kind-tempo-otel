resource "helm_release" "victoria-metrics-single" {
  name             = "victoria-metrics"
  repository       = "https://victoriametrics.github.io/helm-charts/"
  chart            = "victoria-metrics-single"
  namespace        = "monitoring"
  version          = "0.9.17"
  create_namespace = true
  values           = [file("values/monitoring-victoria.yaml")]
  depends_on       = [null_resource.namespace_monitoring, helm_release.istio-ingressgateway]
}

resource "helm_release" "grafana-tempo-distributed" {
  name             = "grafana-tempo-distributed"
  repository       = "https://grafana.github.io/helm-charts"
  chart            = "tempo-distributed"
  namespace        = "monitoring"
  version          = "1.9.1"
  create_namespace = true
  values           = [file("${path.module}/values/monitoring-tempo.yaml")]
  depends_on       = [null_resource.namespace_monitoring, helm_release.istio-ingressgateway]
}

resource "helm_release" "grafana" {
  name             = "grafana"
  repository       = "https://grafana.github.io/helm-charts"
  chart            = "grafana"
  namespace        = "monitoring"
  version          = "7.3.7"
  create_namespace = true
  values           = [file("${path.module}/values/monitoring-grafana.yaml")]
  depends_on       = [helm_release.grafana-tempo-distributed, helm_release.victoria-metrics-single]
}

resource "helm_release" "metrics_server" {
  name       = "metrics-server"
  repository = "https://kubernetes-sigs.github.io/metrics-server/"
  chart      = "metrics-server"
  namespace  = "monitoring"
  version    = "3.12.1"
  wait       = true
  values     = [file("${path.module}/values/monitoring-metrics-server.yaml")]
  depends_on = [null_resource.namespace_monitoring]
}
