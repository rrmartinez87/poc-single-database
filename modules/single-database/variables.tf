/*
  Input variable definitions for an Azure SQL single database resource and its dependences
*/

variable "single_database_name" { 
    description = "The name of the Ms SQL Database. Changing this forces a new resource to be created."
    type = string
}

variable "database_server_id" { 
    description = <<EOT
        The id of the Ms SQL Server on which to create the database.
        Changing this forces a new resource to be created.
        EOT
    type = string
}

variable "service_tier" { 
    description = <<EOT
        Specifies the name of the sku used by the database. Changing this forces a new resource to be created.
        For example, GP_S_Gen5_2,HS_Gen4_1,BC_Gen5_2, ElasticPool, Basic,S0, P2 ,DW100c, DS100.
        Please refer to README.md for additional information on how to use this parameter.
        EOT
    type = string
}

variable "max_size_gb" { 
    description = "The max size of the database in gigabytes."
    type = number
    default = 1
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
        Only available for vCore purchasing model.
        EOT
    type = string
    default = "BasePrice"
}

variable "auto_pause_delay_in_minutes" { 
    description = <<EOT
        Time in minutes after which database is automatically paused. A value of -1 means that automatic
        pause is disabled. This property is only settable for General Purpose Serverless databases.
        EOT
    type = number
    default = -1
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

variable "tags" { 
    description = "A mapping of tags to assign to the resource."
    type = map
}