//--- Set Terraform API version
terraform {
  required_version = ">=0.12.0"
}


//--- Set Azure provider configuration
provider "azurerm" {
    version = "=2.13.0"
    subscription_id = "a265068d-a38b-40a9-8c88-fb7158ccda23"
    features {}
}


//--- Azure resource group definition
resource "azurerm_resource_group" "rg" {

    name = var.resource_group
    location = var.location
    tags = var.tags
}


//--- Create Azure SQL logical database server by using module
module "database_server" {

    source = "./modules/database_server"

    // Set module parameters
    resource_group = azurerm_resource_group.rg.name
    location = azurerm_resource_group.rg.location
    server_name = var.server_name
    tags = var.tags

    // Server and AAD users configuration
    server_admin_login = var.server_admin_login
    create_server_admin_secret = var.create_server_admin_secret
    server_admin_password = var.server_admin_password
    server_admin_key_vault_secret_name = var.server_admin_key_vault_secret_name
    server_admin_key_vault_id = var.server_admin_key_vault_id
    azuread_admin_login = var.azuread_admin_login
    azuread_admin_object_id  = var.azuread_admin_object_id
    azuread_admin_tenant_id = var.azuread_admin_tenant_id
}


//--- Create Azure SQL single database by using module
module "single_database" {

    source = "./modules/single_database"

    // Set module parameters
    single_database_name = var.single_database_name
    database_server_id = module.database_server.server_id
    service_tier = var.service_tier
    max_size_gb = var.max_size_gb
    collation = var.collation
    license_type = var.license_type
    auto_pause_delay_in_minutes = var.auto_pause_delay_in_minutes
    min_vcores_capacity = var.min_vcores_capacity
    secondary_replicas_count = var.secondary_replicas_count
    zone_redundant = var.zone_redundant
    elastic_pool_id = var.elastic_pool_id
    tags = var.tags
}


//-- Create Private Endpoint
module "private_endpoint" {

    source = "./modules/private_endpoint"

    // Set module parameters
    resource_group = azurerm_resource_group.rg.name
    location = azurerm_resource_group.rg.location
    tags = var.tags

    // Endpoint configuration
    vnet_resource_group = var.vnet_resource_group
    private_endpoint_name = var.private_endpoint_name
    subnet_id = module.virtual_network.subnet_id
    private_service_connection_name = var.private_service_connection_name
    database_server_id = module.database_server.server_id
    vnet_id = module.virtual_network.vnet_id
    
    // DNS configuration
    private_dns_zone_name = var.private_dns_zone_name
    private_dns_zone_vnet_link_name = var.private_dns_zone_vnet_link_name
    private_dns_zone_config_name = var.private_dns_zone_config_name
    private_dns_zone_group_name = var.private_dns_zone_group_name

    // A private endpoint can only be deployed in a subnet with specific configuration

}


//--- Create virtual network/subnet to set up private endpoint
module "virtual_network" {

    source = "./modules/virtual_network"

    // Set module parameters
    resource_group = azurerm_resource_group.rg.name
    location = azurerm_resource_group.rg.location
    tags = var.tags
    vnet_name = var.vnet_name
    vnet_address_space = var.vnet_address_space
    subnet_name = var.subnet_name
    subnet_address_prefixes = var.subnet_address_prefixes
}



//--- Create Virtual Machine to test database connectivity
