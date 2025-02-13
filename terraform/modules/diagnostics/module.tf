resource "azurerm_monitor_diagnostic_setting" "diagnostics" {

  for_each = {
    for key, profile in var.profiles : key => profile
    if var.diagnostics.diagnostics_definition != {} # Disable diagnostics when not enabled in the launchpad
  }

  name               = try(format("%s%s", try(var.global_settings.prefix_with_hyphen, ""), each.value.name), format("%s%s", try(var.global_settings.prefix_with_hyphen, ""), var.diagnostics.diagnostics_definition[each.value.definition_key].name))
  target_resource_id = var.resource_id

  eventhub_name                  = var.diagnostics.eventhub_name
  eventhub_authorization_rule_id = var.diagnostics.eventhub_authorization_rule_id

  log_analytics_workspace_id = var.diagnostics.log_analytics_workspaces[var.diagnostics.diagnostics_destinations.log_analytics[each.value.destination_key].log_analytics_key].id
  # Not all diagnostic settings support log analytics destination type "Dedicated"
  # Check https://learn.microsoft.com/en-us/azure/azure-monitor/reference/tables/tables-resourcetype
  log_analytics_destination_type = var.diagnostics.diagnostics_destinations.log_analytics[each.value.destination_key].log_analytics_destination_type

  dynamic "enabled_log" {
    for_each = lookup(var.diagnostics.diagnostics_definition[each.value.definition_key].categories, "log", {})
    content {
      category = enabled_log.value[0]

      dynamic "retention_policy" {
        for_each = length(enabled_log.value) > 1 ? [1] : []
        content {
          enabled = enabled_log.value[1]
          days    = enabled_log.value[2]
        }
      }
    }
  }

  dynamic "metric" {
    for_each = lookup(var.diagnostics.diagnostics_definition[each.value.definition_key].categories, "metric", {})
    content {
      category = metric.value[0]

      dynamic "retention_policy" {
        for_each = length(metric.value) > 1 ? [1] : []
        content {
          enabled = metric.value[1]
          days    = metric.value[2]
        }
      }
    }
  }

  lifecycle {
    ignore_changes = [
      # There's currently a bug in the Azure provider that causes the log_analytics_destination_type to be remain null.
      # This causes Terraform to think that the resource needs to be updated every time it runs.
      log_analytics_destination_type
    ]
  }
}
