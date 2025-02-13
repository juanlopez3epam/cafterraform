output "id" {
  description = "The ID of the Key Vault."
  value       = azurerm_key_vault.keyvault.id
}
output "vault_uri" {
  description = "The URI of the Key Vault."
  value       = azurerm_key_vault.keyvault.vault_uri
}
output "name" {
  description = "The name of the Key Vault."
  value       = azurerm_key_vault.keyvault.name
}
output "rbac_id" {
  description = "The ID of the Key Vault for use with RBAC."
  value       = azurerm_key_vault.keyvault.id
}
output "base_tags" {
  description = "The base tags for the Key Vault from the resource group."
  value       = var.base_tags
}
