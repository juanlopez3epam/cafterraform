resource "azurecaf_name" "fwpol" {
  name          = var.settings.name
  resource_type = "azurerm_firewall_policy"
  prefixes      = var.global_settings.prefixes
  random_length = var.global_settings.random_length
  clean_input   = true
  passthrough   = var.global_settings.passthrough
  use_slug      = var.global_settings.use_slug
}

resource "azurerm_firewall_policy" "fwpol" {
  name                     = azurecaf_name.fwpol.result
  resource_group_name      = var.resource_group.name
  location                 = var.resource_group.location
  sku                      = try(var.settings.sku, "Standard")
  threat_intelligence_mode = try(var.settings.threat_intelligence_mode, "Deny")
  base_policy_id           = var.base_policy_id

  dns {
    proxy_enabled = try(var.settings.dns.enabled, false)
    servers       = try(var.dns_resolver_ip, null) != null ? [var.dns_resolver_ip] : null
  }

  lifecycle {
    ignore_changes = [
      threat_intelligence_allowlist,
      tls_certificate,
      explicit_proxy,
      tags
    ]
  }
}

module "firewall_policy_rule_collection_group" {
  source             = "./rule_collection_group"
  for_each           = var.settings.rule_collection_groups
  name               = each.value.name
  firewall_policy_id = azurerm_firewall_policy.fwpol.id
  priority           = each.value.priority

  application_rule_collections = try(each.value.application_rule_collections, null) != null ? each.value.application_rule_collections : null
  network_rule_collections     = try(each.value.network_rule_collections, null) != null ? each.value.network_rule_collections : null
  nat_rule_collections         = try(each.value.nat_rule_collections, null) != null ? each.value.nat_rule_collections : null
}
