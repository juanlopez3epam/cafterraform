resource "elasticstack_elasticsearch_security_user" "user" {
  username  = var.settings.username
  roles     = var.settings.roles
  password  = var.settings.password_key != null ? var.key_vault_secrets[coalesce(var.settings.lz_key, var.client_config.landingzone_key)][var.settings.password_key].value : null
  email     = var.settings.email
  full_name = var.settings.full_name
  metadata  = jsonencode(var.settings.metadata)
  enabled   = var.settings.enabled
}
