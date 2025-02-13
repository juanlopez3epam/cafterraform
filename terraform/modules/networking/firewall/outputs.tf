output "firewall_private_ip" {
  description = "The private IP address of the firewall"
  value       = azurerm_firewall.fw.virtual_hub[0].private_ip_address # This is a bad assumption, but it'll work for now and can be made more "robust" later.
}

output "firewall_public_ips" {
  description = "The public IPs provisioned by this firewall"
  value       = try(azurerm_firewall.fw.virtual_hub[0].public_ip_addresses, null) != null ? azurerm_firewall.fw.virtual_hub[0].public_ip_addresses : null
}
