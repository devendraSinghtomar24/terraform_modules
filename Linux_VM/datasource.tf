data "azurerm_subnet" "subnet" {
  name                 = "devbackend"
  virtual_network_name = "dev-vnet01"
  resource_group_name  = "dev-rg"
}

data "azurerm_key_vault" "keyvault" {
  name                = "dev-kv89"
  resource_group_name = "dev-rg"
}


data "azurerm_key_vault_secret" "keyvaultsecret2" {
  name         = "adminpassword"
  key_vault_id = data.azurerm_key_vault.keyvault.id
}

