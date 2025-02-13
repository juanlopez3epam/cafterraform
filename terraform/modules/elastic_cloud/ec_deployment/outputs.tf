# output "elasticsearch_endpoint" {
#   value       = format("https://%s.%s:9243",ec_deployment.cluster.id, var.settings.private_endpoint.private_dns["pe"].dns_zone_key)
#   description = "The Elastic Cloud Elastic Search endpoint"
# }
output "elasticsearch_endpoint" {
  value       = format("https://%s.%s:9243", ec_deployment.cluster.elasticsearch.resource_id, var.settings.private_endpoint.private_dns["pe"].dns_zone_key)
  description = "The Elastic Cloud Elastic Search endpoint"
}

output "elasticsearch_username" {
  value       = ec_deployment.cluster.elasticsearch_username
  description = "The Elastic Cloud Elastic Search Username"
}

output "elasticsearch_password" {
  value       = ec_deployment.cluster.elasticsearch_password
  description = "The Elastic Cloud Elastic Search Password"
  sensitive   = true
}

output "elasticsearch_resource_id" {
  value       = ec_deployment.cluster.elasticsearch.resource_id
  description = "The Elastic Cloud Elastic Search Resource Id"
}

output "id" {
  value       = ec_deployment.cluster.id
  description = "The Elastic Cloud Deployment Id"
}

output "kibana_endpoint" {
  value       = try(ec_deployment.cluster.kibana.https_endpoint, null)
  description = "The Elastic Cloud Kibana endpoint"
}

