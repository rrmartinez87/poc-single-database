//--- Set Terraform and cloud provider versions
terraform {
  required_version = ">=0.12.0"

/*
  required_providers {
    azure = "=2.13.0"
  }*/
}

//--- Azure provider configuration
provider "azurerm" {
    version = "=2.13.0"
    subscription_id = "a7b78be8-6f3c-4faf-a43d-285ac7e92a05"
    features {}
}

/* TODO: include tenant_id in server params
data "azurerm_client_config" "current" {
}

output "account_id" {
  value = data.azurerm_client_config.current.client_id
}
*/

//--- Azure resource group definition
resource "azurerm_resource_group" "rg" {

    // Arguments required by Terraform API
    name = var.resource_group
    location = var.location

    // Optional Terraform resource manager arguments but required by architecture
    tags = var.tags
}

//--- Create Azure SQL logical database server by using module
module "database-server" {

    source = "./modules/database-server"

    // Set module parameters
    resource_group = azurerm_resource_group.rg.name
    location = azurerm_resource_group.rg.location
    server_name = var.server_name
    server_admin_login = var.server_admin_login
    create_server_admin_secret = var.create_server_admin_secret
    server_admin_password = var.server_admin_password
    server_admin_key_vault_secret_name = var.server_admin_key_vault_secret_name
    server_admin_key_vault_id = var.server_admin_key_vault_id
    azuread_admin_login = var.azuread_admin_login
    azuread_admin_object_id  = var.azuread_admin_object_id
    tags = var.tags
}

//--- Create Azure SQL single database by using module
module "single-database" {

    source = "./modules/single-database"

    // Set module parameters
    single_database_name = var.single_database_name
    database_server_id = module.database-server.database_server_id //var.database_server_id
    service_tier = var.service_tier
    max_size_gb = var.max_size_gb
    collation = var.collation
    elastic_pool_id = var.elastic_pool_id
    license_type = var.license_type
    auto_pause_delay_in_minutes = var.auto_pause_delay_in_minutes
    min_vcores_capacity = var.min_vcores_capacity
    secondary_replicas_count = var.secondary_replicas_count
    zone_redundant = var.zone_redundant
    tags = var.tags

    //create_logical_database_server = false
}
