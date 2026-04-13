output "aks_cluster_name" {
  value       = azurerm_kubernetes_cluster.aks.name
  description = "AKS cluster name"
}

output "aks_kube_config" {
  value       = azurerm_kubernetes_cluster.aks.kube_config_raw
  sensitive   = true
  description = "Kubernetes config file"
}

output "acr_login_server" {
  value       = azurerm_container_registry.acr.login_server
  description = "ACR login server"
}

output "resource_group_name" {
  value = data.azurerm_resource_group.devsecops.name
}

output "jenkins_ip" {
  value       = azurerm_public_ip.jenkins_ip.ip_address
  description = "Jenkins public IP"
}