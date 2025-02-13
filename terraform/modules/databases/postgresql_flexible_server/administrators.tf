resource "azurerm_postgresql_flexible_server_active_directory_administrator" "pg_aad_admins" {
  for_each = var.settings.postgres_aad_administrators

  server_name         = azurerm_postgresql_flexible_server.postgresql.name
  resource_group_name = azurerm_postgresql_flexible_server.postgresql.resource_group_name

  tenant_id      = each.value.tenant_id == null ? var.client_config.tenant_id : each.value.tenant_id
  object_id      = each.value.object_id
  principal_name = each.value.principal_name
  principal_type = each.value.principal_type
}
