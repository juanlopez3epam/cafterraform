terraform {
  required_version = ">= 1.3.0"
  required_providers {
    castai = {
      source = "castai/castai"
    }
    azurerm = {
      source = "hashicorp/azurerm"
    }
    helm = {
      source = "hashicorp/helm"
    }
  }
}