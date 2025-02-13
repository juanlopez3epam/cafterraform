module "elasticsearch_index_template" {
  source = "../../modules/elasticstack/elasticstack_elasticsearch_index_template"

  for_each = var.elasticsearch_index_templates
  settings = each.value
}

module "elasticsearch_index" {
  source = "../../modules/elasticstack/elasticstack_elasticsearch_index"

  for_each = var.elasticsearch_indexes

  settings = each.value
  depends_on = [
    module.elasticsearch_index_template
  ]
}

module "elasticsearch_security_role" {
  source = "../../modules/elasticstack/elasticstack_elasticsearch_security_role"

  for_each = local.elasticsearch_security_roles

  settings = each.value
}

module "elasticsearch_security_user" {
  source = "../../modules/elasticstack/elasticstack_elasticsearch_security_user"

  for_each = local.elasticsearch_security_users

  client_config     = local.client_config
  settings          = each.value
  key_vault_secrets = local.consolidated_objects_keyvault_dynamic_secrets
  depends_on = [
    module.elasticsearch_security_role,
    module.dynamic_keyvault_secrets,
  ]
}
