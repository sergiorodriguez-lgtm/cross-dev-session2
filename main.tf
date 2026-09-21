terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~> 3.116.0" # This locks the provider to the final stable v3 release
    }
  }
}

provider "azurerm" {
  features {}
  
  skip_provider_registration = true
  use_cli                    = false
  use_oidc                   = false
  use_msi                    = false
  storage_use_azuread        = true
  metadata_host              = "localhost:4577"

  subscription_id = "00000000-0000-0000-0000-000000000000"
  client_id       = "00000000-0000-0000-0000-000000000000"
  client_secret   = "dummy"
  tenant_id       = "00000000-0000-0000-0000-000000000000"
}

resource "azurerm_resource_group" "rg" {
  name     = "local-rg"
  location = "eastus"
}

resource "azurerm_storage_account" "sa" {
  name                     = "localstorage1"
  resource_group_name      = azurerm_resource_group.rg.name
  location                 = azurerm_resource_group.rg.location
  account_tier             = "Standard"
  account_replication_type = "LRS"
}

resource "azurerm_storage_table" "users" {
  name                 = "Users"
  storage_account_name = azurerm_storage_account.sa.name
}