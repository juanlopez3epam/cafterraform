output "vwan" {
  description = "The virtual WAN objects."
  value       = module.virtual_wan
}

output "vhub" {
  description = "The virtual HUB objects."
  value       = module.virtual_hub
}
output "ddos_protection_plans" {
  description = "The DDoS Protection Plan objects."
  value       = local.consolidated_objects_ddos_protection_plans
}

output "private_dns_zones" {
  description = "Private DNS Zones"
  value       = local.consolidated_objects_private_dns_zones
}

output "private_dns_resolvers" {
  description = "Private DNS Resolver objects"
  value       = module.private_dns_resolver
}

output "firewalls" {
  description = "Firewall objects"
  value       = module.firewall
}

output "firewall_policies" {
  description = "Firewall policy objects"
  value       = module.firewall_policies
}

output "virtual_networks" {
  description = "Virtual Networks"
  value       = local.consolidated_objects_virtual_networks
}

output "resource_groups" {
  description = "Resource Groups"
  value       = local.consolidated_objects_resource_groups
}

output "sampleorg_tags" {
  description = "Cloud asset tags"
  value       = local.sampleorg_tags
}

