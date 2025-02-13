output "name" {
  description = "The name of the role"
  value       = elasticstack_elasticsearch_security_role.role.name
}
output "id" {
  description = "The Internal ID of the role"
  value       = elasticstack_elasticsearch_security_role.role.id
}
