resource "azurerm_storage_share" "fs" {
  name                 = var.settings.name
  storage_account_name = var.storage_account_name
  access_tier          = var.settings.access_tier
  quota                = var.settings.quota
  metadata             = var.settings.metadata
  enabled_protocol     = var.settings.enabled_protocol

  dynamic "acl" {
    for_each = { for acl in var.settings.acl : acl.id => acl }
    content {
      id = acl.value.id

      dynamic "access_policy" {
        for_each = try(acl.value.access_policy, null) != null ? [acl.value.access_policy] : []
        content {
          permissions = access_policy.value.permissions
          start       = access_policy.value.start
          expiry      = access_policy.value.expiry
        }
      }
    }
  }
}
