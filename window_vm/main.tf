data "azurerm_subnet" "subnet" {
  name                 = "devbackend"
  virtual_network_name = "dev-vnet01"
  resource_group_name  = "dev-rg"
}

data "azurerm_key_vault" "keyvault" {
  name                = "dev-kv89"
  resource_group_name = "dev-rg"
}

data "azurerm_key_vault_secret" "secret2" {
  name         = "adminpassword"
  key_vault_id = data.azurerm_key_vault.keyvault.id
}
resource "azurerm_public_ip" "pip" {
  for_each            = var.vmname2
  name                = each.value.pipname
  resource_group_name = var.rgname
  location            = var.location
  allocation_method   = "Static"
}



  resource "azurerm_network_interface" "example" {
    for_each            = var.vmname2
    name                = each.value.nicname
    location            = var.location
    resource_group_name = var.rgname


    ip_configuration {
      name                          = "internal"
      subnet_id                     = data.azurerm_subnet.subnet.id
      private_ip_address_allocation = "Dynamic"
      public_ip_address_id          = azurerm_public_ip.pip[each.key].id
    }
  }

  resource "azurerm_windows_virtual_machine" "example2" {
    for_each = var.vmname2
  name                = each.value.name
  resource_group_name = var.rgname
  location            = var.location
  size                = "Standard_F2"
 admin_username      = "admin01"
    admin_password      = data.azurerm_key_vault.keyvault.id
  network_interface_ids = [
    azurerm_network_interface.example[each.key].id
  ]

  os_disk {
    caching              = "ReadWrite"
    storage_account_type = "Standard_LRS"
  }

  source_image_reference {
    publisher = "microsoftwindowsdesktop"
    offer     = "windows-10"
    sku       = "win10-21h2-ent"
    version   = "latest"
  }
}