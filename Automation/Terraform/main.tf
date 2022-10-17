terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "3.22.0"
    }
  }
  backend "azurerm" {
    resource_group_name  = "SA-TF-BACKENDS"
    storage_account_name = "azb23tfremotebackends"
    container_name       = "tfremotebackends"
    key                  = "dev.terraform.tfstate"
  }
}

provider "azurerm" {
  # Configuration options
  features {

  }
}

module "create-rg-01" {
  source = "./modules/rg"
  rg_name = var.rg_01_name
  rg_location = var.rg_01_location
  tag_env_name = var.tag_env_name
}
module "create-rg-02" {
  source = "./modules/rg"
  rg_name = var.rg_02_name
  rg_location = var.rg_02_location
  tag_env_name = var.tag_env_name
}


resource "azurerm_virtual_network" "vnet-01" {
  name                = var.vnet_01_name
  location            = var.rg_01_location
  resource_group_name = var.rg_01_name
  address_space       = var.vnet_01_address_space
  depends_on = [
    module.create-rg-01,
    module.create-rg-02
  ]

  subnet {
    name           = var.subnet1_name
    address_prefix = var.subnet1_address_prefix
  }

  subnet {
    name           = var.subnet2_name
    address_prefix = var.subnet2_address_prefix
  }

  tags = {
    automation  = "terraform"
    environment = var.tag_env_name
  }
}
