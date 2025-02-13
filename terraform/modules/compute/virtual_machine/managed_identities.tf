#
# Managed identities from remote state
#

locals {
  managed_local_identities = flatten([
    for managed_identity_key in try(var.settings.virtual_machine_settings[local.os_type].identity.managed_identity_keys, []) : [
      var.managed_identities[managed_identity_key].id
    ]
  ])

  provided_identities = try(var.settings.virtual_machine_settings[local.os_type].identity.managed_identity_ids, [])

  managed_identities = concat(local.provided_identities, local.managed_local_identities)
}
