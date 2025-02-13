terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~> 3.112.0"
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
      version = "~> 3.4.0"
    }
    tls = {
      source  = "hashicorp/tls"
      version = "~> 4.0.4"
    }
    null = {
      source  = "hashicorp/null"
      version = "~> 3.2.1"
    }
    ec = {
      source  = "elastic/ec"
      version = "~> 0.10.0"
    }
    castai = {
      source  = "castai/castai"
      version = "~> 7.13.1"
    }
  }
  required_version = ">= 1.5.0"
}