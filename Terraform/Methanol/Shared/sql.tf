resource "azurerm_mssql_server" "data-persistent" {
  name                         = "sql-${var.environment_name_suffix}-${var.region_short_name}-${replace(lower(var.project_name), "-test", "")}-${var.resource_suffix}"
  resource_group_name          = data.azurerm_resource_group.rg.name
  location                     = var.region_name
  administrator_login          = local.sql_server_administrator_name
  administrator_login_password = var.sql_server_administrator_password
  version                      = "12.0"
  connection_policy            = "Redirect"
  minimum_tls_version          = "1.2"

  identity {
    type = "SystemAssigned"
  }

  azuread_administrator {
    login_username = var.active_directory_sql_administrator_display_name
    tenant_id      = var.tenant_id
    object_id      = var.active_directory_sql_administrator_object_id
  }

  extended_auditing_policy {
    storage_endpoint                        = azurerm_storage_account.sql-audit.primary_blob_endpoint
    storage_account_access_key              = azurerm_storage_account.sql-audit.primary_access_key
    storage_account_access_key_is_secondary = false
    retention_in_days                       = local.sql_audit_retention_days
  }

  lifecycle {
    prevent_destroy = true
    ignore_changes = [
      tags
    ]
  }
}

resource "azurerm_mssql_database" "paulpoc" {
  name           = "paul_poc_${var.environment_name}"
  server_id      = azurerm_mssql_server.data-persistent.id
  collation      = "SQL_Latin1_General_CP1_CI_AS"
  license_type   = "LicenseIncluded"
  max_size_gb    = local.sql_db_max_size
  read_scale     = var.environment_name_suffix == "prd" ? true : false
  sku_name       = var.sql_sku_name
  zone_redundant = var.environment_name_suffix == "prd" ? true : false

  extended_auditing_policy {
    storage_endpoint                        = azurerm_storage_account.sql-audit.primary_blob_endpoint
    storage_account_access_key              = azurerm_storage_account.sql-audit.primary_access_key
    storage_account_access_key_is_secondary = false
    retention_in_days                       = local.sql_audit_retention_days
  }

  lifecycle {
    prevent_destroy = true
    ignore_changes = [
      tags
    ]
  }

}

resource "azurerm_key_vault_secret" "sql-connection-string" {
  name         = "SqlConnectionString"
  value        = "Server=tcp:${azurerm_mssql_server.data-persistent.fully_qualified_domain_name},1433;Initial Catalog=${azurerm_mssql_database.methanol.name};MultipleActiveResultSets=True;Encrypt=True;"
  key_vault_id = data.azurerm_key_vault.persistent-kv.id
}
