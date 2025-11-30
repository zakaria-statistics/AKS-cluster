output "resource_group_name" {
  value = azurerm_resource_group.rg.name
}

output "aks_name" {
  value = azurerm_kubernetes_cluster.aks.name
}

output "kube_config_command" {
  description = "Command to merge AKS credentials into your kubeconfig"
  value       = "az aks get-credentials --resource-group ${azurerm_resource_group.rg.name} --name ${azurerm_kubernetes_cluster.aks.name}"
}

output "aks_api_server_fqdn" {
  description = "API server endpoint"
  value       = azurerm_kubernetes_cluster.aks.fqdn
}
