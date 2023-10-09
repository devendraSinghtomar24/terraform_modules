data "azurerm_resource_group" "rg" {
  name = "dev-rg"
}

data "azurerm_virtual_network" "vnet" {
  name                = "dev-vnet01"
  resource_group_name = "dev-rg"
}





