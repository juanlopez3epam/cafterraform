locals {
  role_name                      = "CastAKSRole-${var.aks_cluster_name}-TF"
  configuration_id_regex_pattern = "[a-zA-Z0-9]{8}-[a-zA-Z0-9]{4}-[a-zA-Z0-9]{4}-[a-zA-Z0-9]{4}-[a-zA-Z0-9]{12}"
}

resource "castai_aks_cluster" "castai_cluster" {
  name                       = var.aks_cluster_name
  region                     = var.aks_cluster_region
  subscription_id            = var.subscription_id
  tenant_id                  = var.aad_tenant_id
  client_id                  = var.castai_app_clinet_id
  client_secret              = var.castai_app_client_secret
  node_resource_group        = var.aks_node_rg
  delete_nodes_on_disconnect = var.delete_nodes_on_disconnect

  depends_on = [
    azurerm_role_assignment.castai_rg,
    azurerm_role_assignment.castai_node_rg,
    azurerm_role_assignment.castai_additional_rgs
  ]
}

resource "castai_node_configuration" "this" {
  for_each          = { for k, v in var.node_configurations : k => v }
  cluster_id        = castai_aks_cluster.castai_cluster.id
  name              = try(each.value.name, each.key)
  disk_cpu_ratio    = try(each.value.disk_cpu_ratio, 0)
  drain_timeout_sec = try(each.value.drain_timeout_sec, 0)
  min_disk_size     = try(each.value.min_disk_size, 100)
  subnets           = try(each.value.subnets, null)
  ssh_public_key    = try(each.value.ssh_public_key, null)
  image             = try(each.value.image, null)
  tags              = try(each.value.tags, {})

  aks {
    max_pods_per_node = try(each.value.max_pods_per_node, 150)
    os_disk_type      = try(each.value.os_disk_type, null)
  }
}

resource "castai_node_configuration_default" "this" {
  count            = var.cast_ai_read_only ? 0 : 1
  cluster_id       = castai_aks_cluster.castai_cluster.id
  configuration_id = length(regexall(local.configuration_id_regex_pattern, var.default_node_configuration)) > 0 ? var.default_node_configuration : castai_node_configuration.this[var.default_node_configuration].id

  depends_on = [castai_node_configuration.this]
}

resource "castai_node_template" "this" {
  for_each                     = { for k, v in var.node_templates : k => v }
  cluster_id                   = castai_aks_cluster.castai_cluster.id
  name                         = try(each.value.name, each.key)
  is_default                   = try(each.value.is_default, false)
  is_enabled                   = try(each.value.is_enabled, true)
  configuration_id             = can(each.value.configuration_id) ? length(regexall(local.configuration_id_regex_pattern, each.value.configuration_id)) > 0 ? each.value.configuration_id : castai_node_configuration.this[each.value.configuration_id].id : null
  should_taint                 = try(each.value.should_taint, true)
  rebalancing_config_min_nodes = try(each.value.rebalancing_config_min_nodes, 0)

  custom_labels = try(each.value.custom_labels, {})

  dynamic "custom_taints" {
    for_each = flatten([lookup(each.value, "custom_taints", [])])

    content {
      key    = try(custom_taints.value.key, null)
      value  = try(custom_taints.value.value, null)
      effect = try(custom_taints.value.effect, null)
    }
  }

  dynamic "constraints" {
    for_each = flatten([lookup(each.value, "constraints", [])])
    content {
      compute_optimized                           = try(constraints.value.compute_optimized, null)
      storage_optimized                           = try(constraints.value.storage_optimized, null)
      compute_optimized_state                     = try(constraints.value.compute_optimized_state, "")
      storage_optimized_state                     = try(constraints.value.storage_optimized_state, "")
      spot                                        = try(constraints.value.spot, false)
      on_demand                                   = try(constraints.value.on_demand, null)
      use_spot_fallbacks                          = try(constraints.value.use_spot_fallbacks, false)
      fallback_restore_rate_seconds               = try(constraints.value.fallback_restore_rate_seconds, null)
      enable_spot_diversity                       = try(constraints.value.enable_spot_diversity, false)
      spot_diversity_price_increase_limit_percent = try(constraints.value.spot_diversity_price_increase_limit_percent, null)
      spot_interruption_predictions_enabled       = try(constraints.value.spot_interruption_predictions_enabled, false)
      spot_interruption_predictions_type          = try(constraints.value.spot_interruption_predictions_type, null)
      min_cpu                                     = try(constraints.value.min_cpu, null)
      max_cpu                                     = try(constraints.value.max_cpu, null)
      min_memory                                  = try(constraints.value.min_memory, null)
      max_memory                                  = try(constraints.value.max_memory, null)
      architectures                               = try(constraints.value.architectures, ["amd64"])
      os                                          = try(constraints.value.os, ["linux"])
      azs                                         = try(constraints.value.azs, null)

      dynamic "instance_families" {
        for_each = flatten([lookup(constraints.value, "instance_families", [])])

        content {
          include = try(instance_families.value.include, [])
          exclude = try(instance_families.value.exclude, [])
        }
      }

      dynamic "custom_priority" {
        for_each = flatten([lookup(constraints.value, "custom_priority", [])])

        content {
          instance_families = try(custom_priority.value.instance_families, [])
          spot              = try(custom_priority.value.spot, false)
          on_demand         = try(custom_priority.value.on_demand, false)
        }
      }
    }
  }
  depends_on = [castai_autoscaler.castai_autoscaler_policies]
}

// Configure Autoscaler policies as per API specification https://api.cast.ai/v1/spec/#/PoliciesAPI/PoliciesAPIUpsertClusterPolicies.
// Here:
//  - unschedulablePods - Unscheduled pods policy
//  - nodeDownscaler    - Node deletion policy
resource "castai_autoscaler" "castai_autoscaler_policies" {
  count      = var.cast_ai_read_only ? 0 : 1
  cluster_id = castai_aks_cluster.castai_cluster.id

  dynamic "autoscaler_settings" {
    for_each = var.autoscaler_settings != null ? [var.autoscaler_settings] : []

    content {
      enabled                                 = try(autoscaler_settings.value.enabled, null)
      is_scoped_mode                          = try(autoscaler_settings.value.is_scoped_mode, null)
      node_templates_partial_matching_enabled = try(autoscaler_settings.value.node_templates_partial_matching_enabled, null)

      dynamic "unschedulable_pods" {
        for_each = try([autoscaler_settings.value.unschedulable_pods], [])

        content {
          enabled                  = try(unschedulable_pods.value.enabled, null)
          custom_instances_enabled = try(unschedulable_pods.value.custom_instances_enabled, null)

          dynamic "headroom" {
            for_each = try([unschedulable_pods.value.headroom], [])

            content {
              enabled           = try(headroom.value.enabled, null)
              cpu_percentage    = try(headroom.value.cpu_percentage, null)
              memory_percentage = try(headroom.value.memory_percentage, null)
            }
          }

          dynamic "headroom_spot" {
            for_each = try([unschedulable_pods.value.headroom_spot], [])

            content {
              enabled           = try(headroom_spot.value.enabled, null)
              cpu_percentage    = try(headroom_spot.value.cpu_percentage, null)
              memory_percentage = try(headroom_spot.value.memory_percentage, null)
            }
          }

          dynamic "node_constraints" {
            for_each = try([unschedulable_pods.value.node_constraints], [])

            content {
              enabled       = try(node_constraints.value.enabled, null)
              min_cpu_cores = try(node_constraints.value.min_cpu_cores, null)
              max_cpu_cores = try(node_constraints.value.max_cpu_cores, null)
              min_ram_mib   = try(node_constraints.value.min_ram_mib, null)
              max_ram_mib   = try(node_constraints.value.max_ram_mib, null)
            }
          }
        }
      }

      dynamic "cluster_limits" {
        for_each = try([autoscaler_settings.value.cluster_limits], [])

        content {
          enabled = try(cluster_limits.value.enabled, null)


          dynamic "cpu" {
            for_each = try([cluster_limits.value.cpu], [])

            content {
              min_cores = try(cpu.value.min_cores, null)
              max_cores = try(cpu.value.max_cores, null)
            }
          }
        }
      }

      dynamic "spot_instances" {
        for_each = try([autoscaler_settings.value.spot_instances], [])

        content {
          enabled                             = try(spot_instances.value.enabled, null)
          max_reclaim_rate                    = try(spot_instances.value.max_reclaim_rate, null)
          spot_diversity_enabled              = try(spot_instances.value.spot_diversity_enabled, null)
          spot_diversity_price_increase_limit = try(spot_instances.value.spot_diversity_price_increase_limit, null)

          dynamic "spot_backups" {
            for_each = try([spot_instances.value.spot_backups], [])

            content {
              enabled                          = try(spot_backups.value.enabled, null)
              spot_backup_restore_rate_seconds = try(spot_backups.value.spot_backup_restore_rate_seconds, null)
            }
          }

          dynamic "spot_interruption_predictions" {
            for_each = try([spot_instances.value.spot_interruption_predictions], [])

            content {
              enabled                            = try(spot_interruption_predictions.value.enabled, null)
              spot_interruption_predictions_type = try(spot_interruption_predictions.value.spot_interruption_predictions_type, null)
            }
          }
        }
      }

      dynamic "node_downscaler" {
        for_each = try([autoscaler_settings.value.node_downscaler], [])

        content {
          enabled = try(node_downscaler.value.enabled, null)

          dynamic "empty_nodes" {
            for_each = try([node_downscaler.value.empty_nodes], [])

            content {
              enabled       = try(empty_nodes.value.enabled, null)
              delay_seconds = try(empty_nodes.value.delay_seconds, null)
            }
          }

          dynamic "evictor" {
            for_each = try([node_downscaler.value.evictor], [])

            content {
              enabled                                = try(evictor.value.enabled, null)
              dry_run                                = try(evictor.value.dry_run, null)
              aggressive_mode                        = try(evictor.value.aggressive_mode, null)
              scoped_mode                            = try(evictor.value.scoped_mode, null)
              cycle_interval                         = try(evictor.value.cycle_interval, null)
              node_grace_period_minutes              = try(evictor.value.node_grace_period_minutes, null)
              pod_eviction_failure_back_off_interval = try(evictor.value.pod_eviction_failure_back_off_interval, null)
              ignore_pod_disruption_budgets          = try(evictor.value.ignore_pod_disruption_budgets, null)
            }
          }
        }
      }
    }
  }

  depends_on = [
    null_resource.config, null_resource.castai_agent, null_resource.castai_evictor
  ]
}

resource "castai_rebalancing_job" "job" {
  cluster_id              = castai_aks_cluster.castai_cluster.id
  rebalancing_schedule_id = var.castai_rebalancing_schedule_id
  enabled                 = var.castai_rebalancing_schedule_enabled
  depends_on = [
    castai_autoscaler.castai_autoscaler_policies,
    castai_aks_cluster.castai_cluster,
    castai_node_configuration_default.this
  ]
}