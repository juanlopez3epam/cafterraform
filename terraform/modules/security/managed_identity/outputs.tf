output "id" {
  description = "The ID of the User Assigned Managed Identity"
  value       = azurerm_user_assigned_identity.msi.id
}
output "principal_id" {
  description = "The Principal ID of the User Assigned Managed Identity"
  value       = azurerm_user_assigned_identity.msi.principal_id
}
output "client_id" {
  description = "The Client ID of the User Assigned Managed Identity"
  value       = azurerm_user_assigned_identity.msi.client_id
}
output "tenant_id" {
  description = "The Tenant ID of the User Assigned Managed Identity"
  value       = azurerm_user_assigned_identity.msi.tenant_id
}
output "rbac_id" {
  value       = azurerm_user_assigned_identity.msi.principal_id
  description = "This attribute is used to set the role assignment"
}
output "name" {
  description = "Name of the User Assigned Managed Identity"
  value       = azurerm_user_assigned_identity.msi.name
}
output "location" {
  description = "Location of the User Assigned Managed Identity"
  value       = azurerm_user_assigned_identity.msi.location
}
