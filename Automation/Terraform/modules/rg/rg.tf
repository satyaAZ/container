resource "azurerm_resource_group" "main" {
  name     = var.rg_name
  location = var.rg_location
  tags = {
    automation  = "terraform"
    environment = var.tag_env_name
  }
}

output "rg_id" {
  description = "Resource ID of RG"
  value = azurerm_resource_group.main.id
}

output "rg_name" {
  description = "Resource Group Name"
  value = azurerm_resource_group.main.name
}