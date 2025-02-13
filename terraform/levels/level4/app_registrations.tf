module "app_registrations" {
  source = "../../modules/security/app_registration"

  for_each        = local.app_registrations
  name            = each.value.name
  settings        = each.value
  global_settings = var.global_settings
}

