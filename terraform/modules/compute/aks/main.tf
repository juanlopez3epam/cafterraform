terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = ">= 3.112.0"
    }
    azurecaf = {
      source  = "aztfmod/azurecaf"
      version = ">= 1.2.23"
    }
    random = {
      source  = "hashicorp/random"
      version = ">= 3.1.0"
    }
  }
  required_version = ">= 1.3.0"
}

locals {
  aks_dns_name_prefix = try(var.settings.dns_prefix, null) == null && try(var.settings.dns_prefix_private_cluster, null) == null ? random_string.prefix.result : null # If dns_prefix is not set and dns_prefix_private_cluster is not set, use random string
  tags                = merge(var.base_tags, try(var.tags, null))
}

resource "random_string" "prefix" {
  length  = 10
  special = false
  upper   = false
  numeric = false
}
