variable "settings" {
  description = "variables to create elastic search index templates"
  type = object({
    name           = string
    index_patterns = optional(list(string), null)
    priority       = optional(number, 42)
    template = object({
      aliases = optional(map(object({
        name = string
      })), {})
      mappings = optional(string)
      settings = optional(string)
    })
  })
}
