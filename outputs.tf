output "database_id" {
  description = "Id of the database"
  value       = azurerm_mssql_database.database.id
}

output "database_name" {
  description = "Name of the database"
  value       = azurerm_mssql_database.database.name
}

output "database_auditing_policy_id" {
  description = "Id of the MS SQL Database Extended Auditing Policy"
  value       = try(azurerm_mssql_database_extended_auditing_policy.db_auditing_policy[0].id, "")
}
