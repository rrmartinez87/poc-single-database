/*
  Output variable definitions for the Azure virtual network/subnet resource
*/

output "vnet_id" {
  description = "The virtual network ID."
  value = azurerm_virtual_network.vnet.id
  sensitive = false
}

output "subnet_id" {
  description = "The subnet ID."
  value = azurerm_subnet.subnet.id
  sensitive = false
}