resource "azurecaf_name" "registration" {
  name          = var.name
  resource_type = "general"
  prefixes      = try(var.settings.naming_convention.prefixes, try(var.global_settings.prefixes, null))
  suffixes      = try(var.settings.naming_convention.suffixes, try(var.global_settings.suffixes, null))
  random_length = try(var.settings.naming_convention.random_length, try(var.global_settings.random_length, null))
  clean_input   = true
  passthrough   = try(var.settings.naming_convention.passthrough, try(var.global_settings.passthrough, null))
  use_slug      = try(var.settings.naming_convention.use_slug, try(var.global_settings.use_slug, null))
}

data "azuread_client_config" "current" {}

/*data "azuread_user" "owner" {
  user_principal_name = var.settings.owner
}*/

locals {
  app_owners = [
    data.azuread_client_config.current.object_id,
    #data.azuread_user.owner.object_id
  ]
}

resource "azuread_application" "application" {
  display_name = azurecaf_name.registration.result
  owners       = local.app_owners
}

resource "azuread_service_principal" "enterprise_application" {
  application_id = azuread_application.application.application_id
  owners         = local.app_owners

  feature_tags {
    enterprise = true
    gallery    = true
  }

  lifecycle {
    ignore_changes = [
      tags,
    ]
  }
}

resource "azuread_application_password" "application_password" {
  display_name          = azurecaf_name.registration.result
  application_object_id = azuread_application.application.object_id
}