output "id" {
  description = "The ID of the Key Vault."
  value       = azurerm_key_vault_secret.secret.id
}

output "value" {
  description = "The value of the Key Vault secret."
  value       = azurerm_key_vault_secret.secret.value
  sensitive   = true
}

output "name" {
  description = "The name of the Key Vault secret."
  value       = azurerm_key_vault_secret.secret.name
}

output "key_vault_id" {
  description = "The ID of the Key Vault."
  value       = azurerm_key_vault_secret.secret.key_vault_id
}
