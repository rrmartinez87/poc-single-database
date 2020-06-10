// Azure provider configuration
terraform {
  required_version = ">= 0.12"
  backend "azurerm" {}
}
provider "azurerm" {
    version = "~>2.0"
    features {}
	subscription_id = "a7b78be8-6f3c-4faf-a43d-285ac7e92a05"
	tenant_id       = "c160a942-c869-429f-8a96-f8c8296d57db"
 }
// Resource required to generate random guids
resource "random_uuid" "poc" { }

// Azure resource group definition
resource "azurerm_resource_group" "rg" {
  // Create resource group?
  //count = var.create_resource_group ? 1 : 0

  // Arguments required by Terraform API
  name = join(local.separator, [var.resource_group_name, random_uuid.poc.result])
  //name = var.resource_group_name
  location = var.location

  // Optional Terraform resource manager arguments but required by architecture
  tags = var.tags
}

// Azure SQL database server resource definition
resource "azurerm_mssql_server" "dbserver" {
  // Create database server?
  //count = var.create_database_server ? 1 : 0

  // Arguments required by Terraform API
  name = join(local.separator, [var.server_name, random_uuid.poc.result])
  resource_group_name = (azurerm_resource_group.rg != null ? azurerm_resource_group.rg.name : var.resource_group_name)
  //resource_group_name = var.resource_group_name
  location = var.location
  version = var.server_version
  administrator_login = var.administrator_login
  administrator_login_password = var.administrator_login_password
  
  // Optional Terraform resource manager arguments but required by architecture
  connection_policy = local.connection_type
  public_network_access_enabled = local.public_network_access
  tags = var.tags
}

// Azure SQL single database resource definition
resource "azurerm_mssql_database" "singledb" {

  // Arguments required by Terraform API
  name = var.single_database_name
  server_id = azurerm_mssql_server.dbserver.id

  // Optional Terraform resource manager arguments but required by architecture
  max_size_gb = var.max_size_gb
  sku_name = var.service_tier
  tags = var.tags
}

// Create virtual network to set up a private endpoint later
resource "azurerm_virtual_network" "vnet" {
  
  // Arguments required by Terraform API
  name                = join(local.separator, [var.vnet_name, random_uuid.poc.result])
  address_space       = [var.vnet_address_space]
  location            = var.location
  resource_group_name = azurerm_resource_group.rg.name
}

// Create associated subnet
resource "azurerm_subnet" "subnet" {
  
  // Arguments required by Terraform API
  name                 = join(local.separator, [var.subnet_name, random_uuid.poc.result])
  resource_group_name  = azurerm_resource_group.rg.name
  virtual_network_name = azurerm_virtual_network.vnet.name
  address_prefixes     = var.subnet_address_prefixes
  
  // Optional Terraform resource manager arguments but required by architecture
  enforce_private_link_endpoint_network_policies = true
  service_endpoints = ["Microsoft.Sql"]
}

// Create a private endpoint to connect to the server using private access
resource "azurerm_private_endpoint" "endpoint" {
  
  // Arguments required by Terraform API
  name                = join(local.separator, [var.private_endpoint_name, random_uuid.poc.result])
  location            = var.location
  resource_group_name = azurerm_resource_group.rg.name
  subnet_id           = azurerm_subnet.subnet.id

  private_service_connection {
    name                           = var.service_connection_name
    private_connection_resource_id = azurerm_mssql_server.dbserver.id
    is_manual_connection           = false
    subresource_names = ["sqlServer"]
  }
}

// Set database server TLS version after server creation (unsupported Azure provider argument)
// This setting can only be configured once a private enpoint is in place
resource "null_resource" "set_server_tls_version" { 
  provisioner local-exec {
    command = "az sql server update --name ${azurerm_mssql_server.dbserver.name} --resource-group ${azurerm_resource_group.rg.name} --minimal-tls-version ${local.tls_version}"
  }
}

/*
// Create vnet rule for the subnet
resource "azurerm_sql_virtual_network_rule" "vnet_rule" {
  name                = join(local.separator, [var.vnet_rule_name, random_uuid.poc.result])
  resource_group_name = azurerm_resource_group.rg.name
  server_name         = azurerm_mssql_server.dbserver.name
  subnet_id           = azurerm_subnet.subnet.id
  ignore_missing_vnet_service_endpoint = true
}
*/
