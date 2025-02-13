output "firewall_policy_id" {
  description = "The ID of the firewall policy"
  value       = azurerm_firewall_policy.fwpol.id
}
