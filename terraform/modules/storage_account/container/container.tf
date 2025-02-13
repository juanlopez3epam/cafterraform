resource "azurerm_storage_container" "stg" {
  name                  = var.settings.name
  storage_account_name  = var.storage_account_name
  container_access_type = var.settings.access_type
  metadata              = var.settings.metadata
}
