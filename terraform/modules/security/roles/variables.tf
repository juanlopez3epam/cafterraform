variable "client_config" {
  description = "Client configuration"
  type        = any
  default     = {}
}
variable "role_mapping" {
  description = "Role mapping"
  type        = any
}

variable "services_roles" {
  description = "Services roles"
  type = object({
    automations                   = optional(map(any))
    aks_clusters                  = optional(map(any))
    api_management                = optional(map(any))
    app_config                    = optional(map(any))
    app_service_environments      = optional(map(any))
    app_service_environments_v3   = optional(map(any))
    app_service_plans             = optional(map(any))
    app_services                  = optional(map(any))
    application_gateway_platforms = optional(map(any))
    application_gateways          = optional(map(any))
    availability_sets             = optional(map(any))
    azure_container_registries    = optional(map(any))
    azuread_applications          = optional(map(any))
    azuread_apps                  = optional(map(any))
    azuread_groups                = optional(map(any))
    azuread_service_principals    = optional(map(any))
    azuread_users                 = optional(map(any))
    azurerm_firewalls             = optional(map(any))
    backup_vaults                 = optional(map(any))
    batch_accounts                = optional(map(any))
    data_factory                  = optional(map(any))
    databricks_workspaces         = optional(map(any))
    dns_zones                     = optional(map(any))
    function_apps                 = optional(map(any))
    event_hub_namespaces          = optional(map(any))
    keyvaults                     = optional(map(any))
    managed_identities            = optional(map(any))
    management_group              = optional(map(any))
    mssql_databases               = optional(map(any))
    mssql_elastic_pools           = optional(map(any))
    mssql_managed_databases       = optional(map(any))
    mssql_managed_instances       = optional(map(any))
    mssql_servers                 = optional(map(any))
    network_watchers              = optional(map(any))
    networking                    = optional(map(any))
    postgresql_servers            = optional(map(any))
    postgresql_flexible_servers   = optional(map(any))
    private_dns                   = optional(map(any))
    public_ip_addresses           = optional(map(any))
    recovery_vaults               = optional(map(any))
    resource_groups               = optional(map(any))
    storage_accounts              = optional(map(any))
    subscriptions                 = optional(map(any))
    virtual_subnets               = optional(map(any))
    log_analytics                 = optional(map(any))
  })
}

variable "custom_roles" {
  description = "Custom roles"
  type        = any
  default     = {}
}
