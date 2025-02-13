output "name" {
  description = "The name of the HDInsight Kafka cluster."
  value       = azurecaf_name.kafka.result
}

output "id" {
  description = "The ID of the HDInsight Kafka cluster."
  value       = azurerm_hdinsight_kafka_cluster.kafka.id
}

output "https_endpoint" {
  description = "The connection endpoint for the HDInsight Kafka cluster."
  value       = azurerm_hdinsight_kafka_cluster.kafka.https_endpoint
}

output "kafka_rest_proxy_endpoint" {
  description = "The connection endpoint for the HDInsight Kafka REST proxy."
  value       = azurerm_hdinsight_kafka_cluster.kafka.kafka_rest_proxy_endpoint
}

output "ssh_endpoint" {
  description = "The connection endpoint for the HDInsight Kafka cluster."
  value       = azurerm_hdinsight_kafka_cluster.kafka.ssh_endpoint
}
