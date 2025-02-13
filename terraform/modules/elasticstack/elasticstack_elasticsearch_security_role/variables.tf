variable "settings" {
  description = "The settings for the role"
  type = object({
    name    = string
    cluster = optional(list(string), null)
    indices = optional(map(object({
      names      = list(string)
      privileges = list(string)
      field_security = optional(object({
        grant  = optional(list(string), null)
        except = optional(list(string), null)
      }), null)
      query = optional(string, null)
    })), {})
    applications = optional(map(object({
      application = string
      privileges  = list(string)
      resources   = list(string)
    })), {})
    run_as = optional(list(string), null)
  })
}
