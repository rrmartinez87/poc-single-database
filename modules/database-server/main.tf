//--- Create SQL Server Admin secret if requested
//------------------------------------------------
resource "azurerm_key_vault_secret" "secret" {
    
    // Create secret in Azure Key Vault for the server admin password as indicated
    count = var.create_server_admin_secret ? 1 : 0

    // Arguments required by Terraform API
    name = var.server_admin_key_vault_secret_name
    value = var.server_admin_password
    content_type = local.server_admin_secret_content_type
    key_vault_id = var.server_admin_key_vault_id

    //TODO: tags, activation, expiration?
}

// Get SQL Server Admin secret from Azure key Vault
data "azurerm_key_vault_secret" "sqladmin" {

    // Arguments required by Terraform API
    name = var.server_admin_key_vault_secret_name
    key_vault_id = var.server_admin_key_vault_id

    // If a secret is being created as part of the process take it, otherwise get info from an existing one
    depends_on = [ azurerm_key_vault_secret.secret ]
}

//--- Azure SQL Database Server resource definition
//--------------------------------------------------
resource "azurerm_mssql_server" "database_server" {

    // Arguments required by Terraform API
    name = var.server_name
    resource_group_name = var.resource_group
    location = var.location
    version = local.server_version
    administrator_login = var.server_admin_login
    administrator_login_password = data.azurerm_key_vault_secret.sqladmin.value

    // Config Azure AD administrator
    azuread_administrator {
        login_username = var.azuread_admin_login
        object_id = var.azuread_admin_object_id
        tenant_id = var.azuread_tenant_id
    }

    // Optional Terraform resource manager arguments but required by architecture
    connection_policy = local.connection_type
    public_network_access_enabled = local.public_network_access
    tags = var.tags
}

// Set database server TLS version after server creation (unsupported Azure provider argument)
// TODO: This setting can only be configured once a private enpoint is in place???
resource "null_resource" "set_tls_version" { 
    
    provisioner local-exec {
        
        // PowerShell command to update SQL Server TLS version
        command = <<-EOT
            Set-AzSqlServer `
                -ServerName ${azurerm_mssql_server.database_server.name} `
                -ResourceGroupName ${azurerm_mssql_server.database_server.resource_group_name} `
                -MinimalTlsVersion ${local.tls_version}
        EOT

        interpreter = ["pwsh", "-Command"]
    }

    // Setting TLS version requires a previously logical database server to be created
    depends_on = [ azurerm_mssql_server.database_server ]
}