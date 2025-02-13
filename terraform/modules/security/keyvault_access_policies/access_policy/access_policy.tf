resource "azurerm_key_vault_access_policy" "policy" {
  key_vault_id            = var.keyvault_id
  tenant_id               = var.tenant_id
  object_id               = var.object_id
  key_permissions         = var.access_policy.key_permissions
  secret_permissions      = var.access_policy.secret_permissions
  certificate_permissions = var.access_policy.certificate_permissions
  storage_permissions     = var.access_policy.storage_permissions

  timeouts {
    delete = "60m"
  }
}
