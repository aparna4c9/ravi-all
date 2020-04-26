#Fetch the Cloudinit (userdate) file

data "template_file" "web_server" {
  template = file("${path.module}/Templates/cloudnint.tpl")
}

resource "azurerm_availability_set" "main" {
  name                = "${var.prefix}-availset"
  location            = azurerm_resource_group.main.location
  resource_group_name = azurerm_resource_group.main.name
  managed             = true

  tags = {
    environment = "Production"
  }
}

resource "azurerm_virtual_machine" "main" {
  count                 = var.node_count
  name                  = "${var.prefix}-web-${count.index}"
  location              = azurerm_resource_group.main.location
  resource_group_name   = azurerm_resource_group.main.name
  network_interface_ids = [element(azurerm_network_interface.main.*.id, count.index)]
  availability_set_id   = azurerm_availability_set.main.id
  vm_size               = var.vm_size

  # This means the OS Disk will be deleted when Terraform destroys the Virtual Machine
  # NOTE: This may not be optimal in all cases.
  delete_os_disk_on_termination = true

  # This means the Data Disk Disk will be deleted when Terraform destroys the Virtual Machine
  # NOTE: This may not be optimal in all cases.
  delete_data_disks_on_termination = true

  storage_image_reference {
    publisher = "Canonical"
    offer     = "UbuntuServer"
    sku       = "18.04-LTS"
    version   = "latest"
  }

  storage_os_disk {
    name              = "${var.prefix}-${count.index}-osdisk"
    caching           = "ReadWrite"
    create_option     = "FromImage"
    managed_disk_type = "Standard_LRS"
  }

  os_profile {
    computer_name  = "${var.prefix}-web-${count.index}"
    admin_username = var.admin_username
    custom_data    = data.template_file.web_server.rendered
  }

  os_profile_linux_config {
    disable_password_authentication = true
    ssh_keys {
      key_data = file("~/.ssh/id_rsa.pub")
      path     = "/home/${var.admin_username}/.ssh/authorized_keys"
    }
  }
}



