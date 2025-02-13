variable "global_settings" {
  description = "Global settings object (see module README.md)"
  type        = any
  default     = null
}
variable "client_config" {
  description = "Client configuration object (see module README.md)"
  type        = any
  default     = {}
}
variable "aks_cluster_name" {
  description = "Name of the cluster to be connected to CAST AI."
  type        = string
  default     = "team-aks"
}
variable "cast_ai_read_only" {
  type        = bool
  description = "Deploy castai in read-only mode"
  default     = false
}
variable "cast_ai_enabled" {
  type        = bool
  description = "DeplIsoy castai enabled"
  default     = false
}
variable "rg_name" {
  description = "Resource Group Name of AKS Cluster"
  type        = string
  default     = "MDM-RG"
}
variable "subscription_id" {
  description = "Azure Subscription ID"
  type        = string
  default     = ""
}
variable "aks_node_rg" {
  description = "AKS Node Resoure Group Name"
  type        = string
  default     = "RG-MDM-AKS"
}
variable "additional_resource_groups" {
  description = "Additional Resoure Group IDs to provide for castai role assignment"
  type        = list(string)
  default     = []
}
variable "castai_sp_id" {
  description = "Service Principle ID for CastAI (ObjectID of Entrprise Application (castai-{env}-tf))"
  type        = string
  default     = ""
}
variable "aks_cluster_region" {
  description = "Region of the AKS cluster"
  type        = string
  default     = "eastus"
}
variable "aad_tenant_id" {
  description = "ID for Azure AD (tenantId)"
  type        = string
  default     = "e5208e76-dd12-47f0-9541-c9b45afaffe6" # sampleorg.com"
}
variable "deployment_sp_id" {
  description = "Client ID of deployment Service pricipal"
  type        = string
  default     = ""
}
variable "deployment_sp_password" {
  description = "Secret/password of deployment Service pricipal"
  type        = string
  default     = ""
  sensitive   = true
}
variable "castai_app_clinet_id" {
  description = "Client ID of Azure AD castai Application"
  type        = string
  default     = ""
}
variable "castai_app_client_secret" {
  description = "Password (Secret) for castai Application"
  type        = string
  default     = ""
}
variable "delete_nodes_on_disconnect" {
  type        = bool
  description = "Optionally delete Cast AI created nodes when the cluster is destroyed"
  default     = false
}
variable "node_configurations" {
  type        = any
  description = "Map of AKS node configurations to create"
  default     = {}
}
variable "default_node_configuration" {
  type        = string
  description = "ID of the default node configuration"
  default     = null
}
variable "node_templates" {
  type        = any
  description = "Map of node templates to create"
  default     = {}
}
variable "autoscaler_settings" {
  type        = any
  description = "Optional Autoscaler policy definitions to override current autoscaler settings"
  default     = null
}
# Helm Charts
variable "castai_api_token" {
  description = "CastAI API Token (Key)"
  type        = string
  default     = ""
  sensitive   = true
}
variable "castai_api_url" {
  type        = string
  description = "URL of alternative CAST AI API to be used during development or testing"
  default     = "https://api.cast.ai"
}
variable "castai_agent_version" {
  description = "Version of castai-agent helm chart. If not provided, latest version will be used."
  type        = string
  default     = "0.77.2"
}
variable "castai_agent_replica" {
  description = "ReplicaCount for CastAi agent pods"
  type        = number
  default     = 2
}
variable "castai_agent_values" {
  description = "List of YAML formatted string values for agent helm chart"
  type        = list(string)
  default     = []
}
variable "castai_components_labels" {
  description = "Optional additional Kubernetes labels for CAST AI pods"
  type        = map(any)
  default     = {}
}
variable "castai_components_sets" {
  description = "Optional additional 'set' configurations for helm resources."
  type        = map(string)
  default     = {}
}
variable "self_managed" {
  description = "Whether CAST AI components' upgrades are managed by a customer; by default upgrades are managed CAST AI central system."
  type        = bool
  default     = false
}
variable "castai_cluster_controller_version" {
  description = "Version of castai-agent helm chart. If not provided, latest version will be used."
  type        = string
  default     = "0.61.0"
}
variable "castai_cluster_controller_replica" {
  description = "ReplicaCount for CastAi cluster-controller pods"
  type        = number
  default     = 0
}
variable "castai_cluster_controller_values" {
  description = "List of YAML formatted string values for cluster-controller helm chart"
  type        = list(string)
  default     = []
}
variable "wait_for_cluster_ready" {
  description = "Wait for cluster to be ready before finishing the module execution, this option requires `castai_api_token` to be set"
  type        = bool
  default     = false
}
variable "castai_evictor_version" {
  description = "Version of castai-agent helm chart. If not provided, latest version will be used."
  type        = string
  default     = "0.28.27"
}
variable "castai_evictor_values" {
  description = "List of YAML formatted string values for evictor helm chart"
  type        = list(string)
  default     = []
}
variable "castai_evictor_replica" {
  description = "ReplicaCount for CastAi Evictor pods"
  type        = number
  default     = 0
}
variable "castai_evictor_ext_version" {
  description = "Version of castai-agent helm chart. If not provided, latest version will be used."
  type        = string
  default     = "0.1.0"
}
variable "castai_evictor_ext_values" {
  description = "List of YAML formatted string values for evictor helm chart"
  type        = list(string)
  default     = []
}
variable "castai_pod_pinner_version" {
  description = "Version of pod-pinner helm chart. Default latest"
  type        = string
  default     = "0.4.4"
}
variable "castai_grpc_url" {
  type        = string
  description = "gRPC endpoint used by pod-pinner"
  default     = "grpc.cast.ai:443"
}
variable "castai_pod_pinner_replica" {
  description = "Pod Pinner Replica Count"
  type        = number
  default     = 0
}
variable "castai_spot_handler_version" {
  description = "Version of castai-agent helm chart. If not provided, latest version will be used."
  type        = string
  default     = "0.20.0"
}
variable "castai_pod_spot_handler_replica" {
  description = "Number of replicas for the castai-spot-handler"
  type        = number
  default     = 0
}
variable "castai_spot_handler_values" {
  description = "List of YAML formatted string values for spot-handler helm chart"
  type        = list(string)
  default     = []
}
variable "install_castai_security_agent" {
  description = "Optional flag for installation of security agent (https://docs.cast.ai/product-overview/console/security-insights/)"
  type        = bool
  default     = false
}
variable "castai_kvisor_version" {
  description = "Version of castai-agent helm chart. If not provided, latest version will be used."
  type        = string
  default     = "1.0.39"
}
variable "castai_kvisor_values" {
  description = "List of YAML formatted string values for kvisor helm chart"
  type        = list(string)
  default     = []
}
variable "castai_api_grpc_addr" {
  type        = string
  description = "CAST AI GRPC API address"
  default     = "api-grpc.cast.ai:443"
}
variable "castai_workload_autoscaler_version" {
  description = "Version of castai-agent helm chart. If not provided, latest version will be used."
  type        = string
  default     = "0.1.42"
}
variable "castai_pod_workload_autoscaler_replica" {
  description = "Number of replicas for the castai-workload-autoscaler"
  type        = number
  default     = 0
}
variable "castai_rebalancing_schedule_id" {
  type        = string
  description = "CAST AI rebalancing schedule ID"
  default     = "268b7e08-368b-4e5a-8959-7126758a7e1d"  # use API here to get UUID: https://docs.cast.ai/reference/scheduledrebalancingapi_listrebalancingschedules
}
variable "castai_rebalancing_schedule_enabled" {
  description = "Enable CAST AI rebalancing schedule"
  type        = bool
  default     = true
}