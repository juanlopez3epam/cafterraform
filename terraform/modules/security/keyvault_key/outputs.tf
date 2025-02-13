output "id" {
  description = "The ID of the Key Vault Key."
  value       = azurerm_key_vault_key.key.id
}

output "name" {
  description = "The name of the Key Vault Key."
  value       = var.settings.name
}

output "versionless_id" {
  description = "The versionless ID of the Key Vault Key."
  value       = azurerm_key_vault_key.key.versionless_id
}

output "public_key_pem" {
  description = "The PEM of the Key Vault Key."
  value       = azurerm_key_vault_key.key.public_key_pem
}

output "public_key_openssh" {
  description = "The OpenSSH of the Key Vault Key."
  value       = azurerm_key_vault_key.key.public_key_openssh
}
