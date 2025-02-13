terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = ">= 3.47.0"
    }
    azurecaf = {
      source  = "aztfmod/azurecaf"
      version = ">= 1.2.0"
    }
    azuread = {
      source  = "hashicorp/azuread"
      version = "~> 2.31"
    }
  }
  required_version = ">= 1.3.7"
}


locals {
  tags = merge(var.base_tags, try(var.tags, null))
}
