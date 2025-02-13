output "id" {
  description = "The ID of the AKS cluster"
  value       = azurerm_kubernetes_cluster.k8s.id
}
output "cluster_name" {
  description = "The name of the AKS cluster"
  value       = azurecaf_name.aks.result
}
output "resource_group_name" {
  description = "The name of the resource group in which the AKS cluster is created"
  value       = var.resource_group.name
}
output "kubelet_identity" {
  description = "Managed Identity assigned to the Kubelets"
  value       = azurerm_kubernetes_cluster.k8s.kubelet_identity
}
output "identity" {
  description = "System assigned identity which is used by master components"
  value       = azurerm_kubernetes_cluster.k8s.identity
}
output "cluster_identity_rbac_id" {
  description = "The ID of the AKS cluster to be used in RBAC"
  value       = azurerm_kubernetes_cluster.k8s.identity[0].principal_id
}
output "rbac_id" {
  description = "The ID of the AKS cluster kublet identity to be used in RBAC"
  value       = azurerm_kubernetes_cluster.k8s.kubelet_identity[0].object_id
}
output "node_resource_group" {
  description = "The name of the resource group in which the AKS cluster node resources are created"
  value       = azurerm_kubernetes_cluster.k8s.node_resource_group
}
output "node_resource_group_id" {
  description = "The ID of the resource group in which the AKS cluster node resources are created"
  value       = azurerm_kubernetes_cluster.k8s.node_resource_group_id
}
output "private_fqdn" {
  description = "The private FQDN of the AKS cluster"
  value       = azurerm_kubernetes_cluster.k8s.private_fqdn
}
output "oms_agent_identity" {
  description = "The identity of the OMS agent"
  value       = azurerm_kubernetes_cluster.k8s.oms_agent[*].oms_agent_identity[*]
}
output "oidc_issuer_url" {
  description = "The URL of the OpenID Connect issuer"
  value       = azurerm_kubernetes_cluster.k8s.oidc_issuer_url
}
output "key_vault_secrets_provider_identity" {
  description = "The identity of the Key Vault Secrets Provider"
  value       = azurerm_kubernetes_cluster.k8s.key_vault_secrets_provider[*].secret_identity[*]
}