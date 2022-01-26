resource "azurerm_storage_account" "sql-audit" {
  name                     = "sta${lower(var.environment_name_suffix_short)}${var.region_short_name}sqlaudit${var.resource_suffix}"
  resource_group_name      = data.azurerm_resource_group.rg.name
  location                 = var.region_name
  account_replication_type = var.storage_account_replication
  account_tier             = "Standard"
  account_kind             = "StorageV2"
  min_tls_version          = "TLS1_2"
  allow_blob_public_access = false

  lifecycle {
    ignore_changes = [
      tags
    ]
  }
}