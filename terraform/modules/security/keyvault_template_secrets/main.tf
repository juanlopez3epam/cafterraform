terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = ">= 3.39.0"
    }
  }
  required_version = ">= 1.3.7"
}

locals {
  template_folder_path_module = var.settings.template_path == "module" ? "${path.module}/templates" : null
  template_folder_path_level  = var.settings.template_path == "level" ? var.level_path : null
  template_folder_path        = coalesce(local.template_folder_path_module, local.template_folder_path_level, var.settings.template_path)

  # If the template type is multi-line, the template result is the template file itself.
  multi_line_template_result = var.settings.template_type == "multi-line" ? templatefile("${local.template_folder_path}/${var.settings.template_name}.tftpl", local.template_variables) : null
  # If the template type is single-line, the template result is the template file with all newlines removed.
  single_line_template_result = var.settings.template_type == "single-line" ? chomp(templatefile("${local.template_folder_path}/${var.settings.template_name}.tftpl", local.template_variables)) : null

  template_variables = merge({
    for key in keys(var.settings.template_variables) : key => try(local.resource_mapping[var.settings.template_variables[key]].template_value, "")
  })

  resource_mapping = {
    for mapping in flatten(
      [
        for resource_type, all_resources in var.settings.resources : [
          all_resources == null ? [] : [
          for resource_key, object_resources in all_resources : [
            for object_key, object_resource in object_resources : [
              for object_template_keys in object_resource.template_keys : {
                template_key = object_template_keys
                source_value = {
                  resource_type   = resource_type
                  resource_key    = resource_key
                  resource_lz_key = coalesce(try(object_resources.lz_key, null), try(var.client_config.landingzone_key, null))
                  object_key      = object_key
                }
                template_value = try(object_resources.lz_key, null) == null ? var.resources[resource_type][var.client_config.landingzone_key][resource_key][object_key] : var.resources[resource_type][object_resources.lz_key][resource_key][object_key]
              }
            ] if object_key != "lz_key"
          ]
        ]]
      ]
    ) : format("%s", mapping.template_key) => mapping
  }
}
