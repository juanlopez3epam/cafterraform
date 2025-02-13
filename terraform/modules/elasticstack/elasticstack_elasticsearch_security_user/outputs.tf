output "id" {
  description = "The Internal ID of the user"
  value       = elasticstack_elasticsearch_security_user.user.id
}
output "username" {
  description = "The username of the user"
  value       = elasticstack_elasticsearch_security_user.user.username
}
output "password" {
  description = "The password of the user"
  value       = elasticstack_elasticsearch_security_user.user.password
  sensitive   = true
}
output "password_hash" {
  description = "The password hash of the user"
  value       = elasticstack_elasticsearch_security_user.user.password_hash
  sensitive   = true
}
output "roles" {
  description = "The roles of the user"
  value       = elasticstack_elasticsearch_security_user.user.roles
}
output "email" {
  description = "The email of the user"
  value       = elasticstack_elasticsearch_security_user.user.email
}
output "full_name" {
  description = "The full name of the user"
  value       = elasticstack_elasticsearch_security_user.user.full_name
}
output "metadata" {
  description = "The metadata of the user"
  value       = elasticstack_elasticsearch_security_user.user.metadata
}
output "enabled" {
  description = "The enabled state of the user"
  value       = elasticstack_elasticsearch_security_user.user.enabled
}
