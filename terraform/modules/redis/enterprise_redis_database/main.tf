terraform {
  required_providers {
    azurecaf = {
      source  = "aztfmod/azurecaf"
      version = ">= 0.4.17"
    }
    azurerm = {
      source  = "hashicorp/azurerm"
      version = ">= 3.44.0"
    }
  }
  required_version = ">= 1.3.0"
}

locals {
  linked_database_id = var.settings.linked_database_id == null ? null : merge(
    "${var.redis_cluster[var.settings.primary_cluster_key].id}/databases/default",
    [for linked_database in var.settings.linked_database_id : format("%s/databases/%s", var.redis_cluster[linked_database].id, "default")]
  )
}
