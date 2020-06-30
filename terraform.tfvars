//--- Common variables
//---------------------
resource_group = "rg-sql-single-database"
location = "westus2"
tags = {
    environment = "dev"
    product = "mvp"
}


//--- Database server variables
//------------------------------
server_name = "yuma-sqlsvr"
server_admin_login = "yuma-sqlusr"
create_server_admin_secret = false
server_admin_password = "Passw0rd"
server_admin_key_vault_secret_name = "sqlsvr-admin"
server_admin_key_vault_id = "/subscriptions/a265068d-a38b-40a9-8c88-fb7158ccda23/resourceGroups/rg-sql-support/providers/Microsoft.KeyVault/vaults/yuma-keys"
azuread_admin_login = "juanmauricio.garzon@globant.com"
azuread_admin_object_id = "7b1a20dd-eaad-4b76-abbf-c170410f6b46"
azuread_admin_tenant_id = null


//--- Single database variables
//------------------------------
single_database_name = "singledb-mvp"
//database_server_id = "/subscriptions/a265068d-a38b-40a9-8c88-fb7158ccda23/resourceGroups/rg-sql-single-database/providers/Microsoft.Sql/servers/yuma-sqlsvr"
service_tier = "Basic" //ElasticPool//"GP_S_Gen5_2"
max_size_gb = 2
collation = "SQL_Latin1_General_CP1_CI_AS"
license_type = "BasePrice"
auto_pause_delay_in_minutes = 60 // tf only supports from 60 mins ahead
min_vcores_capacity = 1
secondary_replicas_count = 1
zone_redundant  = false
elastic_pool_id = "/subscriptions/a265068d-a38b-40a9-8c88-fb7158ccda23/resourceGroups/rg-sql-single-database/providers/Microsoft.Sql/servers/yuma-sqlsvr/elasticPools/yuma-elastic"


//--- Private Endpoint variables
//-------------------------------
vnet_resource_group = "rg-sql-support"
private_endpoint_name = "private-endpoint"
subnet_id = "/subscriptions/a265068d-a38b-40a9-8c88-fb7158ccda23/resourceGroups/rg-sql-support/providers/Microsoft.Network/virtualNetworks/vnet-endpoint/subnets/subnet-endpoint"
private_service_connection_name = "any_optinal_name"
vnet_id = "/subscriptions/a265068d-a38b-40a9-8c88-fb7158ccda23/resourceGroups/rg-sql-support/providers/Microsoft.Network/virtualNetworks/vnet-endpoint"

//--- DNS configuration
private_dns_zone_name = "privatelink.database.windows.net"
private_dns_zone_vnet_link_name = "private_dsn_zone_vnet_link"
private_dns_zone_config_name = "private_dns_zone_config_name"
private_dns_zone_group_name = "private_dns_zone_group_name"


//--- VNet/Subnet
//----------------
vnet_name = "vnet-endpoint"
vnet_address_space = "10.0.0.0/16"
subnet_name = "subnet-endpoint"
subnet_address_prefixes = ["10.0.1.0/24"]