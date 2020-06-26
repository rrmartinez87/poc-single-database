/*
  Output variable definitions for Azure SQL database server resource
*/

output "database_server_id" {
  description = "The Microsoft SQL Server ID."
  value = azurerm_mssql_server.database_server.id
  sensitive = false
}