variable "settings" {
  description = "variables to create elastic search index"
  type = object({
    name = string
    aliases = optional(map(object({
      name = string
    })), {})
    mappings            = optional(string, null)
    number_of_replicas  = optional(number, 1)
    number_of_shards    = optional(number, 1)
    analysis_normalizer = optional(string, null)
  })
}
