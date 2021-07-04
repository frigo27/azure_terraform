
provider "azurerm" {
  
  features {}
}

resource "azurerm_resource_group" "rg" {
  name= "Atividade4"
  location = "eastus2"
  
}

resource "azurerm_virtual_network" "rg" {
  name                = "rg-network"
  address_space       = ["10.0.0.0/16"]
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name
}

resource "azurerm_subnet" "rg" {
  name                 = "intergal"
  resource_group_name  = azurerm_resource_group.rg.name
  virtual_network_name = azurerm_virtual_network.rg.name
  address_prefixes     = ["10.0.2.0/24"]
}
resource "azurerm_public_ip" "publicIp" {
  name = "publicIP"  
  resource_group_name = azurerm_resource_group.rg.name
  location = azurerm_resource_group.rg.location
    allocation_method   = "Static"

  tags = {
    environment = "teste azure"
  }
}

resource "azurerm_network_interface" "rg" {
  name                = "rg-nic"
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name

  ip_configuration {
    name                          = "intergal"
    subnet_id                     = azurerm_subnet.rg.id
    private_ip_address_allocation = "Dynamic"
    public_ip_address_id          = azurerm_public_ip.publicIp.id
  }
    tags = {
    environment = "teste azure"
  }
}



resource "azurerm_windows_virtual_machine" "rg" {
  name                = "rg-machine"
  resource_group_name = azurerm_resource_group.rg.name
  location            = azurerm_resource_group.rg.location
  size                = "Standard_F2"
  admin_username      = "adminuser"
  admin_password      = "P@$$w0rd1234!"
  network_interface_ids = [
    azurerm_network_interface.rg.id,
  ]

  os_disk {
    caching              = "ReadWrite"
    storage_account_type = "Standard_LRS"
  }

  source_image_reference {
    publisher = "MicrosoftWindowsServer"
    offer     = "WindowsServer"
    sku       = "2019-Datacenter"
    version   = "latest"
  }
}



resource "azurerm_network_security_group" "allow_RDP_in" {
  name                = "rg-machine"
  location            = "eastus2"
  resource_group_name         = azurerm_resource_group.rg.name


  security_rule {
    name                        = "RDP"
    priority                    = 100
    direction                   = "Inbound"
    access                      = "Allow"
    protocol                    = "Tcp"
    source_port_range           = "3389"
    destination_port_range      = "3389"
    source_address_prefix       = "*"
    destination_address_prefix  = "*"
        
  }
  security_rule {
    name                        = "RDP-out"
    priority                    = 110
    direction                   = "Outbound"
    access                      = "Allow"
    protocol                    = "Tcp"
    source_port_range           = "3389"
    destination_port_range      = "3389"
    source_address_prefix       = "*"
    destination_address_prefix  = "*"
    
  }
  security_rule {
    name                        = "WINRM-in"
    priority                    = 120
    direction                   = "Inbound"
    access                      = "Allow"
    protocol                    = "Tcp"
    source_port_range           = "5985"
    destination_port_range      = "5985"
    source_address_prefix       = "*"
    destination_address_prefix  = "*"
  }
  security_rule {
    name                        = "WINRM-out"
    priority                    = 130
    direction                   = "Outbound"
    access                      = "Allow"
    protocol                    = "Tcp"
    source_port_range           = "5985"
    destination_port_range      = "5985"
    source_address_prefix       = "*"
    destination_address_prefix  = "*"
    
  }

  security_rule {
    name                        = "WINRMs-in"
    priority                    = 140
    direction                   = "Inbound"
    access                      = "Allow"
    protocol                    = "Tcp"
    source_port_range           = "5986"
    destination_port_range      = "5986"
    source_address_prefix       = "*"
    destination_address_prefix  = "*"
    
  }
  security_rule {
    name                        = "WINRMs-out"
    priority                    = 150
    direction                   = "Outbound"
    access                      = "Allow"
    protocol                    = "Tcp"
    source_port_range           = "5986"
    destination_port_range      = "5986"
    source_address_prefix       = "*"
    destination_address_prefix  = "*"
  }
}
output "WindowServer2019_public_dns" {
  value = "${azurerm_public_ip.publicIp}"
}

