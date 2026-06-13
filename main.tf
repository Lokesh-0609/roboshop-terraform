resource "azurerm_public_ip" "frontend" {
  name                = "frontend"
  location            = "Denmark East"
  resource_group_name = "denmark-east-rg"
  allocation_method   = "Static"
}


resource "azurerm_network_interface" "frontend" {
  name                = "frontend-nic"
  location            = "denmarkeast"
  resource_group_name = "vm-ware-DenmarkEast"

  ip_configuration {
    name                          = "Lokeshconfiguration1"
    subnet_id                     = "/subscriptions/b1302eea-54e8-482b-a20f-fcc64ece4d78/resourceGroups/vm-ware-DenmarkEast/providers/Microsoft.Network/virtualNetworks/AnsibleControler-vnet/subnets/default/"
    private_ip_address_allocation = "Dynamic"
    public_ip_address_id          = azurerm_public_ip.frontend.id
  }
}


resource "azurerm_linux_virtual_machine" "frontend" {
  name                  = "frontend"
  location              = "denmarkeast"
  resource_group_name   = "vm-ware-DenmarkEast"
  network_interface_ids = [azurerm_network_interface.frontend.id]
  size               = "Standard_B1s"

  source_image_reference {
  publisher = "Canonical"
  offer     = "0001-com-ubuntu-server-jammy"
  sku       = "22_04-lts"
  version   = "latest"
}

  os_disk {
    caching              = "ReadWrite"
    storage_account_type = "Standard_LRS"
  }

  admin_password = "TLokesh@0609L"
  admin_username = "Lokesh"

  disable_password_authentication = false

  secure_boot_enabled = false
  vtpm_enabled        = false

}
resource "azurerm_dns_a_record" "frontend" {
  name                = "frontend-dev"
  zone_name           = "lokeshthokala.online"
  resource_group_name = "vm-ware-DenmarkEast"
  ttl                 = 30
  records             = [azurerm_network_interface.frontend.private_ip_address]
}