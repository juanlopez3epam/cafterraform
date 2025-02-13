# output "virtual_hub" {
#   value = module.virtual_hub

#   description = "Virtual Hubs object"
# }

# output "virtual_wan" {
#   value = azurerm_virtual_wan.vwan

#   description = "Virtual WAN object"
# }


output "id" {
  description = "The ID of the Virtual WAN"
  value       = azurerm_virtual_wan.vwan.id
}
output "name" {
  description = "The name of the Virtual WAN"
  value       = azurerm_virtual_wan.vwan.name
}

output "location" {
  description = "The location of the Virtual WAN"
  value       = azurerm_virtual_wan.vwan.location
}

output "resource_group_name" {
  description = "The name of the resource group where the Virtual WAN is created"
  value       = azurerm_virtual_wan.vwan.resource_group_name
}
