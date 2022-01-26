provider "azurerm" {
    skip_provider_registration = true
}

terraform {
    backend "azurerm" {
        resource_group_name  = "RG-#{Terraform-RG-SUFFIX}#-#{Region-Short}#-#{Terraform-RG}#-#{Resource-Suffix}#"
        storage_account_name = "sta#{Environment-Name}##{Region-Short}#terraform#{Resource-Suffix}#"
        container_name       = "terraform"
        key                  = "#{Project-Name}#-#{Environment-Name}#-#{Region-Short}#-methanol-shared.terraform.tfstate"
    }
}