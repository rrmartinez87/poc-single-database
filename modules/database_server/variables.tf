/*
  Input variable definitions for an Azure SQL database server resource and its dependences
*/

//--- Common variables
//---------------------
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
//------------------------------
variable "create_database_server" { 
    description = "Flag that indicates whether the database server should be created or not."
    type = bool
    default = true
}

variable "server_name" { 
    description = "The name of the Microsoft SQL Server. This needs to be globally unique within Azure."
    type = string
}

variable "server_admin_login"  { 
    description = "The administrator login name for the new server. Changing this forces a new resource to be created."
    type = string
}

variable "create_server_admin_secret"  { 
    description = "The administrator login name for the new server. Changing this forces a new resource to be created."
    type = bool
    default = false
}

variable "server_admin_password"  { 
    description = "The administrator password for the new server, required when create_server_admin_secret is true"
    type = string
    default = null
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

variable "azuread_admin_tenant_id"  { 
    description = "The tenant id of the Azure AD Administrator of this SQL Server."
    type = string
    default = null
}