# Base tf var file to store all the base peroperties and their values

# ==================================================================
# Vnet variables
# ==================================================================
virtual_networks-vnet01-vnet-address_space = ["10.22.0.0/17"]
virtual_networks-vnet01-dns-dns_server_ips = []
virtual_networks-hdinsights-vnet-address_space = ["10.22.128.0/26"]
virtual_networks-confluent-vnet-address_space = ["10.22.128.0/26"]
create-public_ip_address-kong-lb = false
kong-lb-idle-timeout = 10

ddos_protection_plan_enabled = true

private_dns_zones-postgres-name = "stamp-postgres.database.azure.com" #Replace stamp with env name

# ==================================================================
# Terraform Remote State
# ==================================================================
remote_state-resource_group_name = ""
remote_state-storage_account_name = ""