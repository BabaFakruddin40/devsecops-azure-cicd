terraform {
  required_version = ">= 1.0"
  
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~> 3.0"
    }
  }
}

provider "azurerm" {
  features {}
}

# --- DATA SOURCES ---

# Reference the existing Resource Group for the Storage Account
data "azurerm_resource_group" "existing" {
  name = var.existing_rg_name
}

# Reference the DevSecOps Resource Group
data "azurerm_resource_group" "devsecops" {
  name = var.resource_group_name
}

#data "azurerm_storage_account" "storage" {
#  name                = "tfstateaccount28032026"
#  resource_group_name = "tfstate-devsecops-rg"
#}

# --- RESOURCES ---

# Create the Storage Account using the 'existing' RG data source
resource "azurerm_storage_account" "storage" {
  name                     = var.storage_account_name
  resource_group_name      = data.azurerm_resource_group.existing.name
  location                 = data.azurerm_resource_group.existing.location
  
  account_tier             = "Standard"
  account_replication_type = "LRS" 

  tags = {
    environment = "dev"
    Project     = "DevSecOps"
  }
}

