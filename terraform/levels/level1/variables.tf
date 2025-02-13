#tflint-ignore: terraform_unused_declarations
variable "global_settings" {
  type        = any
  description = "Global settings object (see module README.md)"
}
variable "provider_azurerm_features_keyvault" {
  type        = any
  description = "Provider azurerm features keyvault"
  default = {
    purge_soft_delete_on_destroy = true
  }
}
