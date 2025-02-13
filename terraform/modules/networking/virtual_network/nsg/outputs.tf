output "nsg_ids" {
  description = "The ids of the network security groups."
  value       = azurerm_network_security_group.nsg_obj[*]
}

output "nsg_obj" {
  description = "The network security group."
  value       = azurerm_network_security_group.nsg_obj
}
