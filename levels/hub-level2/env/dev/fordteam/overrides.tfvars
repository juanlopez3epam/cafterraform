## Dev tf var file to store all the development peroperties and their values

# ==================================================================
# Vnet variables
# ==================================================================
virtual_networks01-vnet-address_space = ["10.51.0.0/24"]
virtual_networks01-subnets-bastion-cidr = ["10.51.0.0/26"]
virtual_networks01-subnets-jumpbox-cidr = ["10.51.0.64/26"]
virtual_networks01-subnets-dns_resolver-cidr = ["10.51.0.128/26"]

# ==================================================================
# Routes variables
# ==================================================================
jumpbox_route_table_enabled = false
routes-con-01_jumpbox-next_hop_in_ip_address = "10.50.0.132"
routes-con-01_jumpbox2-name = "192.168.0.0"
routes-con-01_jumpbox3-name = "10.0.0.0"
routes-con-01_jumpbox4-name = "172.16.0.0"

# ==================================================================
# Networking variables
# ==================================================================
virtual_hubs-vhub-address_prefix = "10.50.22.0/23"
virtual_hubs-vhub-vnet_connections-internet_security_enabled = false
firewall_enabled = false
firewalls-fw1-sku_tier = "Standard"
firewalls-fw1-vhub-public_ip_count = 10
public_ip_addresses-bastion_host_rg1-sku = "Standard"
aks_dnat-stage_aks_kong_dnat_80-destination_address = "20.228.225.16"
aks_dnat-stage_aks_kong_dnat_80-translated_address = "20.121.145.14"
aks_dnat-stage_aks_kong_dnat_443-destination_address = "20.228.225.16"
aks_dnat-stage_aks_kong_dnat_443-translated_address = "20.121.145.14"

# ==================================================================
# Log analytics variables
# ==================================================================
log_analytics-law_platform-retention_in_days = 30


elastic_cloud_deployments-elastic_cloud_cluster-name = "fordteam1_mi_cl"