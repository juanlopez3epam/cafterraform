output "application_id" {
  description = "The ID of the Application Registration"
  value = azuread_application.application.application_id
}

output "application_object_id" {
  description = "The Object ID of the Application Registration"
  value = azuread_application.application.object_id
}

output "application_client_secret" {
  description = "The Client Secret value for the Application Registration"
  value = azuread_application_password.application_password.value
  sensitive = true
}

output "service_principal_id" {
  description = "The Enterprise Application ID (Same as application id)"
  value = azuread_service_principal.enterprise_application.application_id
}

output "service_principal_object_id" {
  description = "The Enterprise Application Object ID"
  value = azuread_service_principal.enterprise_application.object_id
}