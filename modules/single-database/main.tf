//--- Create logical database server if requested

// module.name.server_id

// Get server as in key vault (with data source)

//--- Azure SQL Single Database resource definition
//-------------------------------------------------
resource "azurerm_mssql_database" "singledb" {

    // Arguments required by Terraform API
    name = var.single_database_name
    server_id = var.database_server_id

    // Optional Terraform resource manager arguments but required by architecture
    max_size_gb = var.max_size_gb
    sku_name = var.service_tier
    collation = var.collation
    license_type = var.license_type
    tags = var.tags

    //--- These parameters apply only to General Purpose Serverless service/compute tier
    auto_pause_delay_in_minutes = (
        substr(var.service_tier, 0, length(local.general_purpose_serverless_service_tier_prefix)) == 
            local.general_purpose_serverless_service_tier_prefix && 
            var.auto_pause_delay_in_minutes >= local.min_auto_pause_supported ?
            var.auto_pause_delay_in_minutes : null
    )
    min_capacity = (
        substr(var.service_tier, 0, length(local.general_purpose_serverless_service_tier_prefix)) == 
            local.general_purpose_serverless_service_tier_prefix ? var.min_vcores_capacity : null
    )
    
    //--- This parameter applies only to Hyperscale service tier
    read_replica_count = (
        substr(var.service_tier, 0, length(local.hyperscale_service_tier_prefix)) == 
            local.hyperscale_service_tier_prefix ? var.secondary_replicas_count : null
    )

    //--- These parameters apply only to Premium and Business Critical service tiers
    read_scale = (
        substr(var.service_tier, 0, length(local.premium_service_tier_prefix)) == local.premium_service_tier_prefix || 
        substr(var.service_tier, 0, length(local.business_critical_service_tier_prefix)) == 
            local.business_critical_service_tier_prefix ? local.read_scale_out : null
    )
    zone_redundant = (
        substr(var.service_tier, 0, length(local.premium_service_tier_prefix)) == local.premium_service_tier_prefix || 
        substr(var.service_tier, 0, length(local.business_critical_service_tier_prefix)) == 
            local.business_critical_service_tier_prefix ? var.zone_redundant : null
    )

    //--- This parameter applies only when creating single pooled database
    elastic_pool_id = var.service_tier == local.elastic_pool_sku_name ? var.elastic_pool_id : null
}