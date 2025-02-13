##Dev tf var file to store all the dev peroperties and their values

# ==================================================================
# Terraform Remote State
# ==================================================================
remote_state-resource_group_name = "sampleorg-dd-eus-mdm-tfbe-rg"
remote_state-storage_account_name = "ivaddeusmdmtfbe01"

lvl4_landingzone_key = "stg_lvl4"
current_landingzone_key = "stg_lvl5"

# ==================================================================
# Redis variables
# ==================================================================
separate-sample_rate_limiting-cache-enabled = false
separate-sample_device_checkin-cache-enabled = false