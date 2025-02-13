output "endpoint" {
  description = "The Elastic Cloud endpoint."
  value       = azurerm_elastic_cloud_elasticsearch.cluster.elasticsearch_service_url
}
output "username" {
  description = "The Elastic Cloud user."
  value       = azurerm_elastic_cloud_elasticsearch.cluster.elastic_cloud_user_id
}
