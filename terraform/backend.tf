terraform {
  backend "azurerm" {
    resource_group_name  = "tfstate-devsecops-rg"
    storage_account_name = "tfstateaccount28032026"
    container_name       = "tfstate"
    key                  = "prod.tfstate"
  }
}