/*
  Input variable definitions for an Azure SQL single database resource and its dependences
*/

// Common variables definition
variable "resource_group_name" { 
    description = "The name of the resource group in which to create the elastic pool. This must be the same as the resource group of the underlying SQL server."
    type = string
    default = "rg-singledb-poc"
}

variable "location" { 
    description = "Specifies the supported Azure location where the resource exists. Changing this forces a new resource to be created."
    type = string
    default = "westus2"
}

variable "tags" { 
    description = "A mapping of tags to assign to the resource."
    type = map
    default = {
        environment = "development"
        product_type = "poc"
    }
}

// Database server variables
variable "server_name" { 
    description = "The name of the Microsoft SQL Server. This needs to be globally unique within Azure."
    type = string
    default = "sql-logical-server"
}

variable "server_version" { 
    description = "The version for the new server. Valid values are: 2.0 (for v11 server) and 12.0 (for v12 server)."
    type = string
    default = "12.0"
}

variable "administrator_login"  { 
    description = "The administrator login name for the new server. Changing this forces a new resource to be created."
    type = string
    default = "yuma-user"
}

variable "administrator_login_password" { 
    description = "The password associated with the administrator_login user. Needs to comply with Azure's Password Policy."
    type = string
    default = "_Adm123$"
}

// Single database variables
variable "single_database_name" { 
    description = "The name of the Ms SQL Database. Changing this forces a new resource to be created."
    type = string
    default = "singledb-poc"
}

variable "service_tier" { 
    description = "The id of the Ms SQL Server on which to create the database. Changing this forces a new resource to be created."
    type = string
    default = "Basic"
}

variable "max_size_gb" { 
    description = "The max size of the database in gigabytes."
    type = number
    default = 2
}

// Virtual network variables
variable "vnet_name" {
    description = "The name of the virtual network. Changing this forces a new resource to be created."
    type = string
    default = "vnet-test"
}

variable "vnet_address_space" {
    description = "The address space that is used the virtual network. You can supply more than one address space. Changing this forces a new resource to be created."
    type = string
    default = "10.2.0.0/16"
}

// Subnet variables
variable "subnet_name" {
    description = "The name of the subnet. Changing this forces a new resource to be created."
    type = string
    default = "subnet"
}

variable "subnet_address_prefixes" {
    description = "The address prefixes to use for the subnet."
    type = list(string)
    default     = ["10.2.0.0/24"]
}

// Private endopoint variables
variable "private_endpoint_name" {
    description = "Specifies the Name of the Private Endpoint. Changing this forces a new resource to be created."
    type = string
    default = "private-endpoint"
}

variable "service_connection_name" {
    description = "Specifies the Name of the Private Service Connection. Changing this forces a new resource to be created."
    type = string
    default = "service_connection_name" 
}

variable "requires_manual_approval" {
    description = "Does the Private Endpoint require Manual Approval from the remote resource owner? Changing this forces a new resource to be created."
    type = bool
    default = false 
}

// Private DNS zone variables
variable "private_dns_zone_name" {
    description = "The name of the Private DNS Zone. Must be a valid domain name."
    type = string
    default = "privatelink.database.windows.net"  
}

variable "private_dns_zone_vnet_link" {
    description = "The name of the Private DNS Zone. Must be a valid domain name."
    type = string
    default = "private_dns_zone_vnet_link"  
}

//--- Virtual machines variables for testing
 
// Ip of the Virtual machine
variable "azurerm_public_ip_name" {
    description = "The name of the Ip"
    type = string
    default = "test-pip"  
}
variable "azurerm_public_ip_allocation_method" {
    description = "ip allocation method"
    type = string
    default = "Dynamic"  
}
variable "azurerm_public_ip_idle_timeout_in_minutes" {
    description = "timeout in minutes"
    type = number
    default = 30
}
variable "azurerm_public_ip_enviroment" {
    description = "ip enviroment"
    type = string
    default = "dev"
}
// Network Interface of the Virtual machine
variable "azurerm_network_interface_name" {
    description = "network interface name"
    type = string
    default = "interface"
}
variable "ip_configuration_name" {
    description = "ip configuration name"
    type = string
    default = "testconfiguration1"
}
variable "private_ip_address_allocation" {
    description = "private ip address allocation"
    type = string
    default = "static"
}
variable "private_ip_address" {
    description = "private ip address allocation"
    type = string
    default = "10.2.0.10"
} 
// Virtual machine to test connectiom
variable "azurerm_virtual_machine_name" {
    description = "(Required) Specifies the name of the Virtual Machine. Changing this forces a new resource to be created."
    type = string
    default = "vmep"
}
variable "azurerm_virtual_machine_vm_size" {
    description = "(Required) Specifies the size of the Virtual Machine."
    type = string
    default = "Standard_B2s"
}
variable "storage_image_reference_publisher" {
    description = "(Required) Specifies the publisher of the image used to create the virtual machine. Changing this forces a new resource to be created."
    type = string
    default = "MicrosoftWindowsServer"
}
variable "storage_image_reference_offer" {
    description = " (Required) Specifies the offer of the image used to create the virtual machine. Changing this forces a new resource to be created."
    type = string
    default = "WindowsServer"
}
variable "storage_image_reference_sku" {
    description = "(Required) Specifies the SKU of the image used to create the virtual machine. Changing this forces a new resource to be created."
    type = string
    default = "2019-Datacenter"
}
variable "storage_image_reference_version" {
    description = "(Optional) Specifies the version of the image used to create the virtual machine. Changing this forces a new resource to be created."
    type = string
    default = "latest"
}
variable "storage_os_disk_name" {
    description = "storage os disk name"
    type = string
    default = "server-os"
}
variable "storage_os_disk_caching" {
    description = "(Optional) Specifies the caching requirements for the Data Disk. Possible values include None, ReadOnly and ReadWrite."
    type = string
    default = "ReadWrite"
}
variable "storage_os_disk_create_option" {
    description = " (Required) Specifies how the data disk should be created. Possible values are Attach, FromImage and Empty."
    type = string
    default = "FromImage"
}
variable "storage_os_disk_managed_disk_type" {
    description = "(Optional) Specifies the type of managed disk to create. Possible values are either Standard_LRS, StandardSSD_LRS, Premium_LRS or UltraSSD_LRS."
    type = string
    default = "Standard_LRS"
}

variable "os_profile_computer_name" {
    description = "(Required) Specifies the name of the Virtual Machine."
    type = string
    default = "vmep"
}
variable "os_profile_admin_username" {
    description = "(Required) Specifies the name of the local administrator account."
    type = string
    default = "adminUsername"
}
variable "os_profile_admin_password" {
    description = "(Optional) Specifies the type of managed disk to create. Possible values are either Standard_LRS, StandardSSD_LRS, Premium_LRS or UltraSSD_LRS."
    type = string
    default = "Passw0rd1234"
}
variable "os_profile_windows_config_provision_vm_agent" {
    description = "(Optional) Should the Azure Virtual Machine Guest Agent be installed on this Virtual Machine? Defaults to false."
    type = bool
    default = true
}
variable "os_profile_windows_config_protocol" {
    description = "(Required) Specifies the protocol of listener. Possible values are HTTP or HTTPS."
    type = string
    default = "HTTP" 
}
