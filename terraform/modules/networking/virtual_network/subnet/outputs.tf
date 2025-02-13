output "id" {
  description = "The ID of the subnet."
  value       = azurerm_subnet.subnet.id
}

output "name" {
  description = "The name of the subnet."
  value       = azurerm_subnet.subnet.name
}

output "cidr" {
  description = "The CIDR of the subnet."
  value       = var.settings.cidr
}
