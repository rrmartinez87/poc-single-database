//--- Common variables
resource_group = "thesqlgroup2"
location = "westus2"
tags = {
    environment = "dev"
    product = "mvp"
}

//--- Database server variables
server_name = "yuma-sqlsvr2"
server_admin_login = "yuma-sqlusr"
create_server_admin_secret = false
server_admin_password = "Passw0rd"
server_admin_key_vault_secret_name = "sqlsvr-admin"
server_admin_key_vault_id = "/subscriptions/a265068d-a38b-40a9-8c88-fb7158ccda23/resourceGroups/rg-sql-kv/providers/Microsoft.KeyVault/vaults/yuma-keys"
azuread_admin_login = "juanmauricio.garzon@globant.com"
azuread_admin_object_id = "7b1a20dd-eaad-4b76-abbf-c170410f6b46"

//--- Single database variables
single_database_name = "singledb-mvp"
//database_server_id = "/subscriptions/a265068d-a38b-40a9-8c88-fb7158ccda23/resourceGroups/thesqlgroup/providers/Microsoft.Sql/servers/yuma-sqlsvr"
service_tier = "Basic"
max_size_gb = 2

// tf only supports from 60 mins ahead
auto_pause_delay_in_minutes = 60
min_vcores_capacity = 1
collation = "SQL_Latin1_General_CP1_CI_AS"
elastic_pool_id = null
license_type = "BasePrice"

secondary_replicas_count = 1
zone_redundant  = false
