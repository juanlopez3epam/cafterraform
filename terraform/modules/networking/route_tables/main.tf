terraform {
  required_providers {
    azurecaf = {
      source  = "aztfmod/azurecaf"
      version = ">= 1.2.23"
    }
    azurerm = {
      source  = "hashicorp/azurerm"
      version = ">= 3.47.0"
    }
  }
  required_version = ">= 1.0.0"
}

locals {
  module_tag = {
    "module" = basename(abspath(path.module))
  }
  tags = merge(var.base_tags, local.module_tag, var.tags)
}
