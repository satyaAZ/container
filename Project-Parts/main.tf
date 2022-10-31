terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "3.25.0"
    }
  }

}

provider "azurerm" {
  # Configuration options
  features {
    resource_group {
      prevent_deletion_if_contains_resources = false
    }
  }
}
resource "azurerm_resource_group" "rg-01" {
  name     = "rg-kfctta-mgmt-uksouth-02"
  location = "uksouth"
}

resource "azurerm_app_service_plan" "asp-01" {
  name                = "parts-appserviceplan"
  location            = azurerm_resource_group.rg-01.location
  resource_group_name = azurerm_resource_group.rg-01.name

  sku {
    tier = "Standard"
    size = "S1"
  }

}

resource "azurerm_app_service" "example" {
  name                = "parts-apps-service-02"
  location            = azurerm_resource_group.rg-01.location
  resource_group_name = azurerm_resource_group.rg-01.name
  app_service_plan_id = azurerm_app_service_plan.asp-01.id

  site_config {
    dotnet_framework_version = "v5.0"
    //scm_type                 = "LocalGit"
  }

  app_settings = {
    "SOME_KEY" = "some-value"
  }
  connection_string {
    name  = "Parts-database"
    type  = "SQLServer"
    value = "Server=tcp:${azurerm_sql_database.az-db.name}.database.windows.net,1433;Initial Catalog=${azurerm_sql_server.sqlserver-01.name};Persist Security Info=False;User ID=${azurerm_sql_server.sqlserver-01.administrator_login};Password=${azurerm_sql_server.sqlserver-01.administrator_login_password};MultipleActiveResultSets=True;Encrypt=True;TrustServerCertificate=False;Connection Timeout=30;"
  }
}
resource "azurerm_sql_server" "sqlserver-01" {
  name                         = "parts-sqlserver2"
  location                     = azurerm_resource_group.rg-01.location
  resource_group_name          = azurerm_resource_group.rg-01.name
  version                      = "12.0"
  administrator_login          = "satya"
  administrator_login_password = "Welcome@321"
  
}

resource "azurerm_sql_database" "az-db" {
  name                = "sample-parts-database"
  resource_group_name = azurerm_resource_group.rg-01.name
  location            = azurerm_resource_group.rg-01.location
  server_name         = azurerm_sql_server.sqlserver-01.name
 
} 
