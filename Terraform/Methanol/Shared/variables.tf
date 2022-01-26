variable "resource_suffix" {
  default     = "001"
  description = "this is in the gateway layer "
}

variable "tenant_id" {
  default     = "94fc63c3-bfea-4ef8-8e7c-817fcabf724f"
  description = "The Azure Active Directory tenant id."
}

# Resource Management

variable "region_name" {
  default     = "UK South"
  description = "The location in which to deploy the resource."
}

variable "region_short_name" {
  default     = "uksouth"
  description = "The location in which to deploy the resource."
}

# Release Information
variable "environment_name" {
  default     = "dev"
  description = "The three-letter environment_name name e.g. dev, test."
}

variable "environment_name_suffix" {
  default     = "dev"
  description = "The three-letter environment_name name e.g. dev, test."
}

variable "environment_name_suffix_short" {
  default     = "dev"
  description = "environment name with suffix without hiphens."
}

variable "project_name" {
  default     = "paulpoc"
  description = "The name of the project."
}

variable "terraform_rg_suffix" {
  description = "shared rg"
}

#Sql
variable "sql_sku_name" {
  description = "Sql SKU name"
  default     = "S0"
}

variable "sql_server_administrator_password" {
  description = "sql server administrator password"
  default     = "0uf_Sl-z7G1jFL3RrZ~5HXyUd6-ss1Z5w5"
}

variable "active_directory_sql_administrator_display_name" {
  description = "AD admin user name"
  default     = "pivey"
}

variable "active_directory_sql_administrator_object_id" {
  description = "AD admin user object id"
  default     = "bb63b0d9-2634-4677-a2b2-a27ab1c3470e"
}

variable "is_DR" {
  default     = false
  type        = bool
  description = "Since dr environment uses existing resources. this flag decides whether to create or use existing."
}

variable "storage_account_replication" {
  default     = "LRS"
  description = "Storage account replication."
}

variable "methanol-project-name" {
  description = "methanol project name where methanol specific resources live."
}

locals {
  keyvault_name                 = var.is_DR ? "kv-${lower(var.environment_name_suffix_short)}-${var.region_short_name}-paulpoc-dr-1" : "kv-${var.environment_name_suffix}-${var.region_short_name}-${replace(replace(lower(var.methanol-project-name), "paul", ""), "-test", "")}-${var.resource_suffix}"
  sql_audit_retention_days      = var.environment_name_suffix == "prd" ? 90 : 7
  sql_db_max_size               = var.environment_name_suffix == "prd" ? 4 : 1
  sql_server_administrator_name = var.environment_name_suffix == "prd" ? "admin" : "${var.environment_name_suffix}.admin"
}