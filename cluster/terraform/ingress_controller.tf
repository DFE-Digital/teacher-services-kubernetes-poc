provider "helm" {
  kubernetes {
    host                   = azurerm_kubernetes_cluster.main.kube_config.0.host
    client_key             = base64decode(azurerm_kubernetes_cluster.main.kube_config.0.client_key)
    client_certificate     = base64decode(azurerm_kubernetes_cluster.main.kube_config.0.client_certificate)
    cluster_ca_certificate = base64decode(azurerm_kubernetes_cluster.main.kube_config.0.cluster_ca_certificate)
  }
}

resource "helm_release" "ingress-nginx" {
  name       = "ingress-nginx"
  repository = "https://kubernetes.github.io/ingress-nginx"
  chart      = "ingress-nginx"
  version    = "4.4.0"

  set {
    name  = "controller.service.annotations.service\\.beta\\.kubernetes\\.io/azure-load-balancer-health-probe-request-path"
    value = "/healthz"
    type  = "string"
  }
}
