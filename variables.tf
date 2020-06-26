/*
  Input variable definitions to create an Azure SQL Single Database resource and its dependences
*/

//--- Common variables
//--------------------
variable "resource_group" { 
    description = "The name of the resource group in which to create the database server. This must be the same as the resource group of the underlying SQL server."
    type = string
}

variable "location" { 
    description = "Specifies the supported Azure location where the resource exists. Changing this forces a new resource to be created."
    type = string
}

variable "tags" { 
    description = "A mapping of tags to assign to the resource."
    type = map
}

//--- Database server variables
//-----------------------------
variable "server_name" { 
    description = "The name of the Microsoft SQL Server. This needs to be globally unique within Azure."
    type = string
}

variable "server_admin_login"  { 
    description = "The administrator login name for the new server. Changing this forces a new resource to be created."
    type = string
}

variable "server_admin_password"  { 
    description = "The administrator password for the new server when create_server_admin_secret is true"
    type = string
    default = ""
}

variable "create_server_admin_secret"  { 
    description = "The administrator login name for the new server. Changing this forces a new resource to be created."
    type = bool
    default = false
}

variable "server_admin_key_vault_secret_name" { 
    description = "Name of the secret in Azure Key Vault where admin password is kept."
    type = string
}

variable "server_admin_key_vault_id" { 
    description = "Azure Key Vault ID where the secret is stored."
    type = string
}

variable "azuread_admin_login"  { 
    description = "The login username of the Azure AD Administrator of this SQL Server."
    type = string
}

variable "azuread_admin_object_id"  { 
    description = "The object id of the Azure AD Administrator of this SQL Server."
    type = string
}

variable "azuread_tenant_id"  { 
    description = "The tenant id of the Azure AD Administrator of this SQL Server."
    type = string
    default = null
}

//--- Single database variables
//-----------------------------

variable "single_database_name" { 
    description = "The name of the Ms SQL Database. Changing this forces a new resource to be created."
    type = string
}

/*
variable "database_server_id" { 
    description = <<EOT
        The id of the Ms SQL Server on which to create the database.
        Changing this forces a new resource to be created.
        EOT
    type = string
}
*/

variable "service_tier" { 
    description = <<EOT
        Specifies the name of the sku used by the database. Changing this forces a new resource to be created.
        For example, GP_S_Gen5_2,HS_Gen4_1,BC_Gen5_2, ElasticPool, Basic,S0, P2 ,DW100c, DS100.
        Please refer to module README.md for additional information on how to use this parameter.
        EOT
    type = string
}

variable "max_size_gb" { 
    description = "The max size of the database in gigabytes."
    type = number
    default = 1
}

variable "auto_pause_delay_in_minutes" { 
    description = <<EOT
        Time in minutes after which database is automatically paused. A value of -1 means that automatic
        pause is disabled. This property is only settable for General Purpose Serverless databases.
        EOT
    type = number
    default = -1
}

variable "collation" { 
    description = "Specifies the collation of the database. Changing this forces a new resource to be created."
    type = string
    default = "SQL_Latin1_General_CP1_CI_AS"
}

variable "elastic_pool_id" { 
    description = <<EOT
        Specifies the ID of the elastic pool containing this database.
        Changing this forces a new resource to be created.
        EOT
    type = string
    default = null
}

variable "license_type" { 
    description = <<EOT
        Specifies the license type applied to this database. Possible values are LicenseIncluded
        (Azure Hybrid Benefit included) and BasePrice (Azure Hybrid Benefit not included).
        EOT
    type = string
    default = "BasePrice"
}

variable "min_vcores_capacity" { 
    description = <<EOT
        Minimal vCores capacity that database will always have allocated, if not paused.
        This property is only settable for General Purpose Serverless databases.
        EOT
    type = number
    default = 1
}

variable "secondary_replicas_count" { 
    description = <<EOT
        The number of readonly secondary replicas associated with the database to which readonly
        application intent connections may be routed. This property is only settable for
        Hyperscale edition databases.
        EOT
    type = number
    default = 0
}

variable "zone_redundant" { 
    description = <<EOT
        Whether or not this database is zone redundant, which means the replicas of this database
        will be spread across multiple availability zones. This property is only settable for
        Premium and Business Critical databases.
        EOT
    type = bool
    default = false
}