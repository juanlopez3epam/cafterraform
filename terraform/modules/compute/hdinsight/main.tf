terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = ">= 3.47.0"
    }
    azurecaf = {
      source  = "aztfmod/azurecaf"
      version = ">= 1.2.23"
    }
    random = {
      source  = "hashicorp/random"
      version = ">= 3.1.0"
    }
    tls = {
      source  = "hashicorp/tls"
      version = "~> 4.0.4"
    }
  }
  required_version = ">= 1.3.0"
}

locals {
  module_tag = {
    "module"   = basename(abspath(path.module))
    "keyvault" = var.keyvaults[var.client_config.landingzone_key][var.settings.keyvault_key].name
  }
  tags = merge(var.base_tags, local.module_tag, try(var.settings.tags, null))
}
