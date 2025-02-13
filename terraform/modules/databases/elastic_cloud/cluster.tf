resource "azurerm_elastic_cloud_elasticsearch" "cluster" {
  name                        = var.settings.name
  resource_group_name         = var.resource_group.name
  location                    = var.resource_group.location
  sku_name                    = var.settings.sku_name
  elastic_cloud_email_address = var.settings.elastic_cloud_email_address
}
