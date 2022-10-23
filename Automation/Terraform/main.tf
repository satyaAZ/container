terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "3.22.0"
    }
  }
  backend "azurerm" {
    resource_group_name  = "SA-TF-BACKENDS"
    storage_account_name = "azb23tfremotebackend"
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


resource "azurerm_virtual_network" "vnet-01" {
  name                = var.vnet_01_name
  location            = var.rg_01_location
  resource_group_name = var.rg_01_name
  address_space       = var.vnet_01_address_space
  depends_on = [
    module.create-rg-01
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

resource "azurerm_service_plan" "asp-01" {
  name                = "asp-webapps-01"
  resource_group_name = var.rg_01_name
  location            = var.rg_01_location
  sku_name            = "P1v2"
  os_type             = "Windows"
}

resource "azurerm_windows_web_app" "app-01" {
  name                = "azb23-win-app-01"
  resource_group_name = var.rg_01_name
  location            = var.rg_01_location
  service_plan_id     = azurerm_service_plan.asp-01.id

  site_config {}
  
  connection_string {
    name  = "Parts-database"
    type  = "SQLServer"
    value = "Server=tcp:${azurerm_sql_database.sql-db-01.name}.database.windows.net,1433;Initial Catalog=${azurerm_sql_server.sql-server-01.name};Persist Security Info=False;User ID=${azurerm_sql_server.sql-server-01.administrator_login};Password=${azurerm_sql_server.sql-server-01.administrator_login_password};MultipleActiveResultSets=True;Encrypt=True;TrustServerCertificate=False;Connection Timeout=30;"
  }
}

resource "azurerm_sql_server" "sql-server-01" {
  name                         = "azb23-sql-server-01"
  resource_group_name = var.rg_01_name
  location            = var.rg_01_location
  version                      = "12.0"
  administrator_login          = "vineel"
  administrator_login_password = "4-v3ry-53cr37-p455w0rd"

 tags = {
    automation  = "terraform"
    environment = var.tag_env_name
  }
}

resource "azurerm_sql_database" "sql-db-01" {
  name                = "azb23-db-01"
  resource_group_name = var.rg_01_name
  location            = var.rg_01_location
  server_name         = azurerm_sql_server.sql-server-01.name
  tags = {
    automation  = "terraform"
    environment = var.tag_env_name
  }
}
