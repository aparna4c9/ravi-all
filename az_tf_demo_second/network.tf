resource "azurerm_virtual_network" "main" {
  name                = "${var.prefix}-vnet"
  address_space       = var.vnet_cidr_block
  location            = azurerm_resource_group.main.location
  resource_group_name = azurerm_resource_group.main.name
  tags                = var.tags
}

resource "azurerm_subnet" "frontend" {
  name                 = "web"
  resource_group_name  = azurerm_resource_group.main.name
  virtual_network_name = azurerm_virtual_network.main.name
  address_prefix       = var.frontend_subnet_cidr
}

resource "azurerm_public_ip" "main" {
  count               = var.node_count
  name                = "${var.prefix}-${count.index}-pip"
  resource_group_name = azurerm_resource_group.main.name
  location            = azurerm_resource_group.main.location
  allocation_method   = "Static"
  tags                = var.tags
}


resource "azurerm_network_interface" "main" {
  count                     = var.node_count
  name                      = "${var.prefix}-nic-${count.index}"
  location                  = azurerm_resource_group.main.location
  resource_group_name       = azurerm_resource_group.main.name
  network_security_group_id = azurerm_network_security_group.web.id

  ip_configuration {
    name                          = "configuration-${count.index}"
    subnet_id                     = azurerm_subnet.frontend.id
    private_ip_address_allocation = "dynamic"
    public_ip_address_id          = element(azurerm_public_ip.main.*.id, count.index)
  }

}
resource "azurerm_network_security_group" "web" {
  name                = "webservers"
  location            = azurerm_resource_group.main.location
  resource_group_name = azurerm_resource_group.main.name
  security_rule {
    name                       = "ssh-access-rule"
    direction                  = "Inbound"
    access                     = "Allow"
    priority                   = 200
    source_address_prefix      = "*"
    source_port_range          = "*"
    destination_address_prefix = "*"
    destination_port_range     = "22"
    protocol                   = "TCP"
  }

  security_rule {
    name                       = "http-rule"
    direction                  = "Inbound"
    access                     = "Allow"
    priority                   = 300
    source_address_prefix      = "*"
    source_port_range          = "*"
    destination_address_prefix = "*"
    destination_port_range     = "80"
    protocol                   = "TCP"
  }
}



output "public_ip" {
  value = "${azurerm_public_ip.main.*.ip_address}"
}