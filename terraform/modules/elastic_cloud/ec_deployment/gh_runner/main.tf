terraform {
  required_providers {
    ec = {
      source  = "elastic/ec"
      version = ">= 0.10.0"
    }
    azurerm = {
      source  = "hashicorp/azurerm"
      version = ">= 3.0.0"
      configuration_aliases = [ azurerm.gh_runner ]
    }
    azapi = {
      source = "azure/azapi"
    }
  }
  required_version = ">= 1.3.0"
}

