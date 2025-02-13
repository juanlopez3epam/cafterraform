## Dev profile tf var file to store all the Dev peroperties and their values
# ==================================================================
# Tagging variables
# ==================================================================
tag_bussines_unit = "Engineering"
tag_cogs = "Yes"
tag_cost_center = "Test"
tag_team = "DL-Eng-MIDevOps@sampleorg.com"
tag_environment = "Development"

# ==================================================================
# KeyVault variables
# ==================================================================
### Level 2
keyvault_access_policies-ssh_keys-aad_group-object_id = ""

# ==================================================================
# Log analytics variables
# ==================================================================
log_analytics-law_platform-retention_in_days = 30

# ==================================================================
# Networking variables
# ==================================================================
firewalls-fw1-sku_tier = "Standard"
firewalls-fw1-vhub-public_ip_count = 10
public_ip_addresses-bastion_host_rg1-sku = "Standard"
ddos_protection_plan_enabled = false
