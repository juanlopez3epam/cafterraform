terraform {
  required_providers {
    confluent = {
      source = "confluentinc/confluent"
      version = ">=1.61.0"
    }
    azurerm = {
      source  = "hashicorp/azurerm"
      version = ">= 3.0.0"
      configuration_aliases = [ azurerm.gh_runner ]
    }
  }
  
  required_version = ">= 1.3.0"
}