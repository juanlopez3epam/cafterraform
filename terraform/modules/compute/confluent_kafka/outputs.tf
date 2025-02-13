
output "id" {
  description = "The ID of the Confluent Cloud Kafka cluster."
  value       = confluent_kafka_cluster.cluster_re1.id
}

output "https_endpoint" {
  description = "The Confluent Cloud kafka bootstrap endpoint."
  value       = confluent_kafka_cluster.cluster_re1.bootstrap_endpoint
}

output "kafka_rest_proxy_endpoint" {
  description = "The connection endpoint for the Confluent Cloud Kafka REST proxy."
  value       = confluent_kafka_cluster.cluster_re1.rest_endpoint
}

output "kafka-api-key-id" {
  description = "The  Confluent Cloud Kafka API key ID."
  value       = confluent_api_key.admin-sa-kafka-api-key.id
}

output "kafka-api-key-secret" {
  description = "The  Confluent Cloud Kafka API key secret."
  value       = confluent_api_key.admin-sa-kafka-api-key.secret
}
