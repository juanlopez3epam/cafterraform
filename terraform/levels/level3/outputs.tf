output "resource_groups" {
  value       = local.consolidated_objects_resource_groups
  description = "Resource groups"
}

output "vnets" {
  value       = local.consolidated_objects_virtual_networks
  description = "Virtual networks"
}

output "container_registries" {
  value       = local.consolidated_objects_container_registries
  description = "Container registries"
}

output "log_analytics_workspaces" {
  value       = local.consolidated_objects_log_analytics_workspaces
  description = "Log Analytics Instances"
  sensitive   = true
}

output "private_dns_zones" {
  value       = local.consolidated_objects_private_dns_zones
  description = "Private DNS Zones"
}

output "ddos_protection_plans" {
  value       = local.consolidated_objects_ddos_protection_plans
  description = "DDoS Protection Plans"
}
