terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = ">= 3.39.0"
    }
    random = {
      source  = "hashicorp/random"
      version = "~> 3.4"
    }
  }
  required_version = ">= 1.3.7"
}
locals {
  tags = try(var.global_settings.inherit_tags, false) ? try(var.keyvault.base_tags, {}) : {}
}
