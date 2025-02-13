terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = ">= 3.39.0"
    }
  }
  required_version = ">= 1.3.7"
}
locals {
  base_tags = try(var.global_settings.inherit_tags, false) ? try(var.keyvault.base_tags, {}) : {}
  tags      = merge(local.base_tags, try(var.settings.tags, {}))
}
