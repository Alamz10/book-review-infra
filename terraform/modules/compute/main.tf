
resource "azurerm_public_ip" "frontend_pip" {
  name                = "${var.application_name}-${var.environment}frontend-pip"
  resource_group_name = var.resource_group_name
  location            = var.location
  allocation_method   = "static"
}

resource "azurerm_network_interface" "frontend_nic" {
  name                = "${var.application_name}-${var.environment}frontend-nic"
  location            = var.location
  resource_group_name = var.resource_group_name

  ip_configuration {
    name                          = "internal"
    subnet_id                     = var.subnet_id
    private_ip_address_allocation = "Dynamic"
    public_ip_address_id          = azurerm_public_ip.frontend_pip.id
  }
}

resource "azurerm_public_ip" "backend_pip" {
  name                = "${var.application_name}-${var.environment}backend-pip"
  resource_group_name = var.resource_group_name
  location            = var.location
  allocation_method   = "static"
}

resource "azurerm_network_interface" "backend_nic" {
  name                = "${var.application_name}-${var.environment}backeend-nic"
  location            = var.location
  resource_group_name = var.resource_group_name

  ip_configuration {
    name                          = "internal"
    subnet_id                     = var.subnet_id
    private_ip_address_allocation = "Dynamic"
    public_ip_address_id          = azurerm_public_ip.backend_pip.id
  }
}

resource "azurerm_linux_virtual_machine" "frontend_vm" {
  name                  = "${var.application_name}-${var.environment}-frontend-vm"
  resource_group_name   = var.resource_group_name
  location              = var.location
  size                  = var.vm_size
  admin_username        = var.admin_username
  network_interface_ids = [azurerm_network_interface.frontend_nic.id]

  os_disk {
    caching              = "ReadWrite"
    storage_account_type = "Standard_LRS"
    name                 = "${var.application_name}-${var.environment}-frontend-vm-disk"
  }

  admin_ssh_key {
    username   = "olasadada"
    public_key = file("${path.module}/id_rsa.pub")
  }

  source_image_reference {
    publisher = "Canonical"
    offer     = "0001-com-ubuntu-server-jammy"
    sku       = "22_04-lts"
    version   = "latest"
  }

  disable_password_authentication = true
}


resource "azurerm_linux_virtual_machine" "backend_vm" {

  name                = "${var.application_name}-${var.environment}-backend-vm"
  resource_group_name = var.resource_group_name
  location            = var.location
  size                = var.vm_size
  admin_username      = var.admin_username

  network_interface_ids = [
    azurerm_network_interface.backend_nic.id
  ]

  os_disk {
    caching              = "ReadWrite"
    storage_account_type = "Standard_LRS"
    name                 = "${var.application_name}-${var.environment}-backend-vm-disk"
  }

  admin_ssh_key {
    username   = var.admin_username
    public_key = file("${path.module}/id_rsa.pub")
  }

  source_image_reference {
    publisher = "Canonical"
    offer     = "0001-com-ubuntu-server-jammy"
    sku       = "22_04-lts"
    version   = "latest"
  }

  disable_password_authentication = true
}

  