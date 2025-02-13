locals {

eventhub_name = var.eventhub_name
eventhub_authorization_rule_id = var.eventhub_authorization_rule_id

diagnostics_definition = {
  redis_all = {
    name = "operational_logs_and_metrics"
    categories = {
      log = [
        # ["Category name",  "Diagnostics Enabled(true/false)", "Retention Enabled(true/false)", Retention_period]
        ["ConnectedClientList", var.diagnostics_definition-redis_all-diagnostics_enabled,  var.diagnostics_definition-redis_all-retention_period],
      ]
      metric = [
        #["Category name",  "Diagnostics Enabled(true/false)", "Retention Enabled(true/false)", Retention_period]
        ["AllMetrics", var.diagnostics_definition-redis_all-diagnostics_enabled,  var.diagnostics_definition-redis_all-retention_period],
      ]
    }
  }

  enterprise_redis_all = {
    name = "operational_logs_and_metrics"
    categories = {
      log = []
      metric = [
        #["Category name",  "Diagnostics Enabled(true/false)", "Retention Enabled(true/false)", Retention_period]
        ["AllMetrics", var.diagnostics_definition-enterprise_redis_all-diagnostics_enabled, var.diagnostics_definition-enterprise_redis_all-retention_period],
      ]
    }
  }

  azure_kubernetes_cluster = {
    name = "operational_logs_and_metrics"
    categories = {
      log = [
        # ["Category name",  "Diagnostics Enabled(true/false)", "Retention Enabled(true/false)", Retention_period]
        ["cloud-controller-manager", var.diagnostics_definition-azure_kubernetes_cluster-diagnostics_enabled, var.diagnostics_definition-azure_kubernetes_cluster-retention_period],
        ["cluster-autoscaler", var.diagnostics_definition-azure_kubernetes_cluster-diagnostics_enabled,  var.diagnostics_definition-azure_kubernetes_cluster-retention_period],
        ["csi-azuredisk-controller", var.diagnostics_definition-azure_kubernetes_cluster-diagnostics_enabled,  var.diagnostics_definition-azure_kubernetes_cluster-retention_period],
        ["csi-azurefile-controller", var.diagnostics_definition-azure_kubernetes_cluster-diagnostics_enabled,  var.diagnostics_definition-azure_kubernetes_cluster-retention_period],
        ["csi-snapshot-controller", var.diagnostics_definition-azure_kubernetes_cluster-diagnostics_enabled,  var.diagnostics_definition-azure_kubernetes_cluster-retention_period],
        ["guard", var.diagnostics_definition-azure_kubernetes_cluster-diagnostics_enabled,  var.diagnostics_definition-azure_kubernetes_cluster-retention_period],
        ["kube-apiserver", var.diagnostics_definition-azure_kubernetes_cluster-diagnostics_enabled,  var.diagnostics_definition-azure_kubernetes_cluster-retention_period],
        ["kube-audit", var.diagnostics_definition-azure_kubernetes_cluster-diagnostics_enabled,  var.diagnostics_definition-azure_kubernetes_cluster-retention_period],
        ["kube-audit-admin", var.diagnostics_definition-azure_kubernetes_cluster-diagnostics_enabled,  var.diagnostics_definition-azure_kubernetes_cluster-retention_period],
        ["kube-controller-manager", var.diagnostics_definition-azure_kubernetes_cluster-diagnostics_enabled,  var.diagnostics_definition-azure_kubernetes_cluster-retention_period],
        ["kube-scheduler", var.diagnostics_definition-azure_kubernetes_cluster-diagnostics_enabled, var.diagnostics_definition-azure_kubernetes_cluster-retention_period],
      ]
      metric = [
        #["Category name",  "Diagnostics Enabled(true/false)", "Retention Enabled(true/false)", Retention_period]
        ["AllMetrics", var.diagnostics_definition-azure_kubernetes_cluster-diagnostics_enabled, var.diagnostics_definition-azure_kubernetes_cluster-retention_period],
      ]
    }
  }

  postgresql = {
    name = "operational_logs_and_metrics"
    categories = {
      log = [
        # ["Category name",  "Diagnostics Enabled(true/false)", "Retention Enabled(true/false)", Retention_period]
        ["PostgreSQLLogs", var.diagnostics_definition-postgresql-diagnostics_enabled, var.diagnostics_definition-postgresql-retention_period],
        ["PostgreSQLFlexSessions", var.diagnostics_definition-postgresql-diagnostics_enabled, var.diagnostics_definition-postgresql-retention_period],
        ["PostgreSQLFlexQueryStoreRuntime", var.diagnostics_definition-postgresql-diagnostics_enabled, var.diagnostics_definition-postgresql-retention_period],
        ["PostgreSQLFlexQueryStoreWaitStats", var.diagnostics_definition-postgresql-diagnostics_enabled, var.diagnostics_definition-postgresql-retention_period],
        ["PostgreSQLFlexTableStats", var.diagnostics_definition-postgresql-diagnostics_enabled, var.diagnostics_definition-postgresql-retention_period],
        ["PostgreSQLFlexDatabaseXacts", var.diagnostics_definition-postgresql-diagnostics_enabled, var.diagnostics_definition-postgresql-retention_period],
      ]
      metric = [
        #["Category name",  "Diagnostics Enabled(true/false)", "Retention Enabled(true/false)", Retention_period]
        ["AllMetrics", var.diagnostics_definition-postgresql-diagnostics_enabled, var.diagnostics_definition-postgresql-retention_period],
      ]
    }
  }

  keyvault = {
    name = "operational_logs_and_metrics"
    categories = {
      log = [
        # ["Category name",  "Diagnostics Enabled(true/false)", "Retention Enabled(true/false)", Retention_period]
        ["AuditEvent", var.diagnostics_definition-keyvault-diagnostics_enabled, var.diagnostics_definition-keyvault-retention_period],
        ["AzurePolicyEvaluationDetails", var.diagnostics_definition-keyvault-diagnostics_enabled, var.diagnostics_definition-keyvault-retention_period],
      ]
      metric = [
        #["Category name",  "Diagnostics Enabled(true/false)", "Retention Enabled(true/false)", Retention_period]
        ["AllMetrics", var.diagnostics_definition-keyvault-diagnostics_enabled, var.diagnostics_definition-keyvault-retention_period],
      ]
    }
  }
}

# Defines the different destination for the different log profiles
# Different profiles to target different operational teams

diagnostics_destinations = {
  log_analytics = {
    central_logs_dedicated = {
      log_analytics_key              = "law1"
      log_analytics_destination_type = "Dedicated"
    }
    central_logs_legacy = {
      log_analytics_key              = "law1"
      log_analytics_destination_type = "AzureDiagnostics"
    }
  }
}

}