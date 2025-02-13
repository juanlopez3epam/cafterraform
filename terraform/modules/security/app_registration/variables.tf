variable "global_settings" {
  description = "Global settings object (see module README.md)"
  type        = any
}
variable "settings" {
  description = "App Registration settings object (see module README.md)"
  type        = any
}
variable "name" {
  description = "Name of the App Registration"
  type        = string
}

variable "tags" {
  description = "(optional) Map of tags to be applied to the resource"
  type        = map(any)
  default     = null
}

variable "base_tags" {
  description = "Base tags for the resource to be inherited from the resource group."
  type        = map(any)
  default     = null
}

