terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = ">= 3.0"
    }
    azurecaf = {
      source  = "aztfmod/azurecaf"
      version = ">= 1.0"
    }
  }
  required_version = ">= 1.3.0"
}


locals {
  tags = merge(var.base_tags, try(var.tags, null))
}
