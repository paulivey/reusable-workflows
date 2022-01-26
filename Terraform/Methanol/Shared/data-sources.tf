data "azurerm_resource_group" "rg" {
  name = "RG-${upper(var.terraform_rg_suffix)}-${upper(var.region_short_name)}-${upper(var.project_name)}-${var.resource_suffix}"
}

data "azurerm_key_vault" "persistent-kv" {
  name                = local.keyvault_name
  resource_group_name = "RG-${upper(var.terraform_rg_suffix)}-${upper(var.region_short_name)}-${upper(var.methanol-project-name)}-${var.resource_suffix}"
}