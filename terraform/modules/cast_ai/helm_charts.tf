resource "null_resource" "config" {
  triggers = {
    apiURL                             = var.castai_api_url
    grpcURL                            = var.castai_grpc_url
    grpcAddr                           = var.castai_api_grpc_addr
    apiKey                             = var.castai_api_token
    clusterID                          = castai_aks_cluster.castai_cluster.id
    castai_agent_version               = var.castai_agent_version
    castai_cluster_controller_version  = var.castai_cluster_controller_version
    castai_evictor_version             = var.castai_evictor_version
    castai_evictor_ext_version         = var.castai_evictor_ext_version
    castai_pod_pinner_version          = var.castai_pod_pinner_version
    castai_spot_handler_version        = var.castai_spot_handler_version
    castai_kvisor_version              = var.castai_kvisor_version
    castai_workload_autoscaler_version = var.castai_workload_autoscaler_version
    always_run                         = "${timestamp()}"
  }

  provisioner "local-exec" {
    interpreter = ["bash", "-c"]
    command     = <<EOT
      set -x
      SUBSCRIPTION_ID="${var.global_settings.default_subscription_id}"
      az login --service-principal --username ${var.deployment_sp_id} --password ${var.deployment_sp_password} --tenant ${var.global_settings.tenant_id}
      if [ $? -ne 0 ]; then
        echo "Error: az login failed. Please check the credentials provided"
        exit 1
      fi
      az account set --subscription $SUBSCRIPTION_ID
      if [ $? -ne 0 ]; then
        echo "Error: az account subscription $SUBSCRIPTION_ID set failed"
        exit 1
      fi
      az aks get-credentials --resource-group ${var.rg_name} --name ${var.aks_cluster_name} --admin --overwrite-existing
      if [ $? -ne 0 ]; then
        echo "Error: az aks get-credentials failed"
        exit 1
      fi
      kubectl config current-context
      if [ $(kubectl get ns | grep castai-agent } | wc -l) -eq 0 ];
      then
        kubectl create namespace castai-agent
      else
        echo "castai-agent namepsace exists"
      fi
      helm repo add castai-helm https://castai.github.io/helm-charts
      helm repo update
      helm ls
      kubectl get all -n castai-agent
    EOT
  }
}

resource "null_resource" "castai_agent" {
  triggers = {
    apiURL               = var.castai_api_url
    apiKey               = var.castai_api_token
    castai_agent_version = var.castai_agent_version
    castai_agent_replica = var.castai_agent_replica
    always_run           = "${timestamp()}"
  }

  provisioner "local-exec" {
    interpreter = ["bash", "-c"]
    command     = <<EOT
    set -x
    helm upgrade -i castai-agent castai-helm/castai-agent -n castai-agent --version ${var.castai_agent_version} \
      --set provider="aks" \
      --set createNamespace=false \
      --set apiURL=${var.castai_api_url} \
      --set apiKey=${var.castai_api_token} \
      --set replicaCount=${var.castai_agent_replica}
    EOT
  }

  depends_on = [null_resource.config]
}

resource "null_resource" "castai_cluster_controller" {
  count    = var.cast_ai_read_only ? 0 : 1
  triggers = {
    apiURL                            = var.castai_api_url
    apiKey                            = var.castai_api_token
    clusterID                         = castai_aks_cluster.castai_cluster.id
    castai_cluster_controller_version = var.castai_cluster_controller_version
    replicas                          = var.castai_cluster_controller_replica
    always_run                        = "${timestamp()}"          
  }

  provisioner "local-exec" {
    interpreter = ["bash", "-c"]
    command     = <<EOT
    set -x
    helm upgrade -i cluster-controller castai-helm/castai-cluster-controller -n castai-agent --version ${var.castai_cluster_controller_version} \
      --set aks.enabled=true \
      --set replicas=${var.castai_cluster_controller_replica} \
      --set castai.apiURL=${var.castai_api_url} \
      --set castai.apiKey=${castai_aks_cluster.castai_cluster.cluster_token} \
      --set castai.clusterID=${castai_aks_cluster.castai_cluster.id}
    EOT
  }

  depends_on = [null_resource.config, null_resource.castai_agent]
}

resource "null_resource" "wait_for_cluster" {
  count = (var.wait_for_cluster_ready && var.cast_ai_read_only == false) ? 1 : 0

  triggers = {
    clusterID = castai_aks_cluster.castai_cluster.id
  }

  provisioner "local-exec" {
    interpreter = ["bash", "-c"]
    environment = {
      API_KEY = var.castai_api_token
    }
    command = <<-EOT
        RETRY_COUNT=60
        POOLING_INTERVAL=60

        for i in $(seq 1 $RETRY_COUNT); do
            sleep $POOLING_INTERVAL
            curl -s ${var.castai_api_url}/v1/kubernetes/external-clusters/${castai_aks_cluster.castai_cluster.id} -H "x-api-key: $API_KEY" | grep '"status"\s*:\s*"ready"' && exit 0
        done

        echo "Cluster is not ready after 60 minutes"
        exit 1
    EOT
  }

  depends_on = [null_resource.config, null_resource.castai_agent, null_resource.castai_cluster_controller]
}

resource "null_resource" "castai_evictor" {
  count    = var.cast_ai_read_only ? 0 : 1
  triggers = {
    apiURL                 = var.castai_api_url
    apiKey                 = var.castai_api_token
    clusterID              = castai_aks_cluster.castai_cluster.id
    castai_evictor_version = var.castai_evictor_version
    replicaCount           = var.castai_evictor_replica
    always_run             = "${timestamp()}"
  }

  provisioner "local-exec" {
    interpreter = ["bash", "-c"]
    command     = <<EOT
    set -x
    helm upgrade -i castai-evictor castai-helm/castai-evictor -n castai-agent --version ${var.castai_evictor_version} \
      --set castai-evictor-ext.enabled=false \
      --set replicaCount=${var.castai_evictor_replica}
    EOT
  }

  depends_on = [null_resource.config, null_resource.castai_agent]
}


resource "null_resource" "castai_evictor_ext" {
  count    = var.cast_ai_read_only ? 0 : 1
  triggers = {
    apiURL                 = var.castai_api_url
    apiKey                 = var.castai_api_token
    clusterID              = castai_aks_cluster.castai_cluster.id
    castai_evictor_version = var.castai_evictor_ext_version
    always_run             = "${timestamp()}"
  }

  provisioner "local-exec" {
    interpreter = ["bash", "-c"]
    command     = <<EOT
    set -x
    helm upgrade -i castai-evictor-ext castai-helm/castai-evictor-ext -n castai-agent --version ${var.castai_evictor_ext_version}
    EOT
  }

  depends_on = [null_resource.config, null_resource.castai_agent]
}

resource "null_resource" "castai_pod_pinner" {
  count    = var.cast_ai_read_only ? 0 : 1
  triggers = {
    apiURL                    = var.castai_api_url
    apiKey                    = var.castai_api_token
    clusterID                 = castai_aks_cluster.castai_cluster.id
    castai_pod_pinner_version = var.castai_pod_pinner_version
    replicaCount              = var.castai_pod_pinner_replica
    always_run                = "${timestamp()}"
  }

  provisioner "local-exec" {
    interpreter = ["bash", "-c"]
    command     = <<EOT
    set -x
    helm upgrade -i castai-pod-pinner castai-helm/castai-pod-pinner -n castai-agent --version ${var.castai_pod_pinner_version} \
      --set castai.apiURL=${var.castai_api_url} \
      --set castai.apiKey=${castai_aks_cluster.castai_cluster.cluster_token} \
      --set castai.clusterID=${castai_aks_cluster.castai_cluster.id} \
      --set castai.grpcURL=${var.castai_grpc_url} \
      --set replicaCount=${var.castai_pod_pinner_replica}
    EOT
  }

  depends_on = [null_resource.config, null_resource.castai_agent]
}

resource "null_resource" "castai_spot_handler" {
  count    = var.cast_ai_read_only ? 0 : 1
  triggers = {
    apiURL                      = var.castai_api_url
    apiKey                      = castai_aks_cluster.castai_cluster.cluster_token
    clusterID                   = castai_aks_cluster.castai_cluster.id
    castai_spot_handler_version = var.castai_spot_handler_version
    replicaCount                = var.castai_pod_spot_handler_replica
    always_run                  = "${timestamp()}"
  }

  provisioner "local-exec" {
    interpreter = ["bash", "-c"]
    command     = <<EOT
    set -x
    helm upgrade -i castai-spot-handler castai-helm/castai-spot-handler -n castai-agent --version ${var.castai_spot_handler_version} \
      --set castai.provider="azure" \
      --set createNamespace=false \
      --set castai.apiURL=${var.castai_api_url} \
      --set castai.clusterID=${castai_aks_cluster.castai_cluster.id} \
      --set replicaCount=${var.castai_pod_spot_handler_replica}
    EOT
  }

  depends_on = [null_resource.config, null_resource.castai_agent]
}

resource "null_resource" "castai_kvisor" {
  count = var.install_castai_security_agent ? 1 : 0

  triggers = {
    apiKey                = var.castai_api_token
    clusterID             = castai_aks_cluster.castai_cluster.id
    castai_kvisor_version = var.castai_kvisor_version
    grpcAddr              = var.castai_api_grpc_addr
  }

  provisioner "local-exec" {
    interpreter = ["bash", "-c"]
    command     = <<EOT
    set -x
    helm upgrade -i castai-kvisor castai-helm/castai-kvisor -n castai-agent --version ${var.castai_kvisor_version} \
      --set castai.apiKey=${castai_aks_cluster.castai_cluster.cluster_token} \
      --set castai.clusterID=${castai_aks_cluster.castai_cluster.id} \
      --set castai.grpcAddr=${var.castai_api_grpc_addr} \
      --set controller.extraArgs.kube-linter-enabled=true \
      --set controller.extraArgs.image-scan-enabled=true \
      --set controller.extraArgs.kube-bench-enabled=true \
      --set controller.extraArgs.kube-bench-cloud-provider=aks
    EOT
  }

  depends_on = [null_resource.config, null_resource.castai_agent]
}

resource "null_resource" "castai_workload_autoscaler" {
  count    = var.cast_ai_read_only ? 0 : 1
  triggers = {
    apiKey                             = var.castai_api_token
    clusterID                          = castai_aks_cluster.castai_cluster.id
    castai_workload_autoscaler_version = var.castai_workload_autoscaler_version
    replicas                           = var.castai_pod_workload_autoscaler_replica
    always_run                         = "${timestamp()}"
  }

  provisioner "local-exec" {
    interpreter = ["bash", "-c"]
    command     = <<EOT
    set -x
    helm upgrade -i castai-workload-autoscaler castai-helm/castai-workload-autoscaler -n castai-agent --version ${var.castai_workload_autoscaler_version} \
      --set replicas=${var.castai_pod_workload_autoscaler_replica} \
      --set castai.apiKeySecretRef="castai-agent" \
      --set castai.configMapRef="castai-cluster-controller"
    EOT
  }

  depends_on = [null_resource.config, null_resource.castai_agent]
}

resource "null_resource" "unset_config" {
  triggers = {
    always_run                         = "${timestamp()}"
  }

  provisioner "local-exec" {
    interpreter = ["bash", "-c"]
    command     = <<EOT
      set -x
      kubectl config unset current-context
      if [ $? -ne 0 ]; then
        echo "Error: unsetting current context failed"
      fi
    EOT
  }
  depends_on = [null_resource.config, null_resource.castai_agent, null_resource.castai_cluster_controller, null_resource.wait_for_cluster, null_resource.castai_evictor, null_resource.castai_evictor_ext, null_resource.castai_pod_pinner, null_resource.castai_spot_handler, null_resource.castai_kvisor, null_resource.castai_workload_autoscaler]
}