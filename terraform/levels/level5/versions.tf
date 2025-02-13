terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~> 3.47.0"
    }
    azuread = {
      source  = "hashicorp/azuread"
      version = "~> 2.31.0"
    }
    azurecaf = {
      source  = "aztfmod/azurecaf"
      version = "~> 1.2.23"
    }
    random = {
      source  = "hashicorp/random"
      version = "~> 3.4"
    }
    github = {
      source  = "integrations/github"
      version = "~> 4.17.0"
    }
    vault = {
      source  = "hashicorp/vault"
      version = "~> 3.12.0"
    }
    elasticstack = {
      source  = "elastic/elasticstack"
      version = "~> 0.5.0"
    }
  }
  required_version = ">= 1.5.0"
}
