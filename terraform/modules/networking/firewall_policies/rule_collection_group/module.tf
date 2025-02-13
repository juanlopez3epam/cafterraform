resource "azurerm_firewall_policy_rule_collection_group" "rule_collection_group" {
  name               = var.name
  firewall_policy_id = var.firewall_policy_id
  priority           = var.priority

  dynamic "application_rule_collection" {
    for_each = try(var.application_rule_collections, null) != null ? var.application_rule_collections : {}
    content {
      name     = application_rule_collection.value.name
      priority = application_rule_collection.value.priority
      action   = application_rule_collection.value.action
      dynamic "rule" {
        for_each = application_rule_collection.value.rules
        content {
          name                  = rule.value.name
          description           = try(rule.value.description, null)
          source_addresses      = try(rule.value.source_addresses, null)
          source_ip_groups      = try(rule.value.source_ip_groups, null)
          destination_addresses = try(rule.value.destination_addresses, null)
          destination_urls      = try(rule.value.destination_urls, null)  # Conflicts with destination_fqdns
          destination_fqdns     = try(rule.value.destination_fqdns, null) # Conflicts with destination_urls
          destination_fqdn_tags = try(rule.value.destination_fqdn_tags, null)
          terminate_tls         = try(rule.value.terminate_tls, null) # Must be 'true' when using destination_urls
          web_categories        = try(rule.value.web_categories, null)
          dynamic "protocols" {
            for_each = try(rule.value.protocols, {})
            content {
              type = protocols.value.type
              port = protocols.value.port
            }
          }
        }
      }
    }
  }

  dynamic "network_rule_collection" {
    for_each = try(var.network_rule_collections, null) != null ? var.network_rule_collections : {}
    content {
      name     = network_rule_collection.value.name
      priority = coalesce(try(network_rule_collection.value.priority, null), 500)
      action   = network_rule_collection.value.action
      dynamic "rule" {
        for_each = network_rule_collection.value.rules
        content {
          name                  = rule.value.name
          protocols             = rule.value.protocols
          destination_ports     = rule.value.destination_ports
          source_addresses      = try(rule.value.source_addresses, null)
          source_ip_groups      = try(rule.value.source_ip_groups, null)
          destination_addresses = try(rule.value.destination_addresses, null)
          destination_ip_groups = try(rule.value.destination_ip_groups, null)
          destination_fqdns     = try(rule.value.destination_fqdns, null)
        }
      }
    }
  }

  dynamic "nat_rule_collection" {
    for_each = try(var.nat_rule_collections, null) != null ? var.nat_rule_collections : {}
    content {
      name     = nat_rule_collection.value.name
      priority = nat_rule_collection.value.priority
      action   = "Dnat" # This is the only allowed value here
      dynamic "rule" {
        for_each = nat_rule_collection.value.rules
        content {
          name                = rule.value.name
          protocols           = rule.value.protocols
          translated_port     = rule.value.translated_port
          source_addresses    = try(rule.value.source_addresses, null)
          source_ip_groups    = try(rule.value.source_ip_groups, null)
          destination_address = try(rule.value.destination_address, null)
          destination_ports   = try(rule.value.destination_ports, null)  # Only one port is allowed, even though this has to be passed as a list
          translated_address  = try(rule.value.translated_address, null) # Exactly one of translated_address and translated_fqdn should be set per rule
          translated_fqdn     = try(rule.value.translated_fqdn, null)    # Exactly one of translated_address and translated_fqdn should be set per rule
        }
      }
    }
  }
}
