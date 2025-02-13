terraform {
  required_providers {
    azurecaf = {
      source  = "aztfmod/azurecaf"
      version = ">= 0.4.17"
    }
    azurerm = {
      source  = "hashicorp/azurerm"
      version = ">= 3.47.0"
    }
  }
  required_version = ">= 1.3.0"
}

locals {
  tags = merge(var.base_tags, try(var.tags, null))
}
