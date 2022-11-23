resource "azurerm_resource_group" "rg" {
  location = var.resource_group_location
  name     = var.rgName
}

# Create virtual network
resource "azurerm_virtual_network" "virtual_network" {
  name                = var.vnetName
  address_space       = [var.vnetAddressSpace]
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name
}

# Create subnet
resource "azurerm_subnet" "workloadSubnet" {
  name                 = var.workloadSubnetName
  resource_group_name  = azurerm_resource_group.rg.name
  virtual_network_name = azurerm_virtual_network.virtual_network.name
  address_prefixes     = [var.workloadSubnetAddressPrefix]
}

resource "azurerm_network_security_group" "webserver" {
  name                = "${var.webPrefix}nsg"
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name
  security_rule {
    access                     = "Allow"
    direction                  = "Inbound"
    name                       = "http"
    priority                   = 1000
    protocol                   = "Tcp"
    source_port_range          = "*"
    source_address_prefix      = "*"
    destination_port_ranges     = ["8080", "8443","80","443"]
    destination_address_prefix = azurerm_subnet.workloadSubnet.address_prefixes[0]
  }
}
resource "azurerm_subnet_network_security_group_association" "workloadsubnetasc" {
  subnet_id                 = azurerm_subnet.workloadSubnet.id
  network_security_group_id = azurerm_network_security_group.webserver.id
}
#################### VM Management ####################
#################### / VM Management ##################
#################### LB ######################
#################### / LB ####################
#################### vm web ####################
# Create network interface
resource "azurerm_network_interface" "web_nic1" {
  name                = "${var.webPrefix}nic1"
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name

  ip_configuration {
    name                          = "my_nic_configuration"
    subnet_id                     = azurerm_subnet.workloadSubnet.id
    private_ip_address_allocation = "Dynamic"
  }
}

# Create (and display) an SSH key
resource "tls_private_key" "web_ssh1" {
  algorithm = "RSA"
  rsa_bits  = 4096
}
data "template_file" "web_user_data" {
  template = filebase64("./cloud-init_web.yaml")
}
# Create virtual machine
resource "azurerm_linux_virtual_machine" "web_vm1" {
  name                  = "${var.webPrefix}vm1"
  location              = azurerm_resource_group.rg.location
  resource_group_name   = azurerm_resource_group.rg.name
  network_interface_ids = [azurerm_network_interface.web_nic1.id]
  size                  = var.vmSize

  os_disk {
    name                 = "${var.webPrefix}OsDisk1"
    caching              = "ReadWrite"
    storage_account_type = "Standard_LRS"
  }

  source_image_reference {
    publisher = "Canonical"
    offer     = "UbuntuServer"
    sku       = "18.04-LTS"
    version   = "latest"
  }

  computer_name                   = "${var.webPrefix}vm1"
  admin_username                  = "azureuser"
  admin_password                  = "someSecurePass!123"
  disable_password_authentication = false
  user_data                       = data.template_file.web_user_data.rendered

  admin_ssh_key {
    username   = "azureuser"
    public_key = tls_private_key.web_ssh1.public_key_openssh
  }
}


#################### / vm web ####################

#################### vm gis ####################
# Create network interface
resource "azurerm_network_interface" "gis_nic1" {
  name                = "${var.gisPrefix}nic"
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name

  ip_configuration {
    name                          = "my_nic_configuration"
    subnet_id                     = azurerm_subnet.workloadSubnet.id
    private_ip_address_allocation = "Dynamic"
  }
}

# Create (and display) an SSH key
resource "tls_private_key" "gis_ssh1" {
  algorithm = "RSA"
  rsa_bits  = 4096
}

data "template_file" "gis_user_data" {
  template = filebase64("./cloud-init_gis.yaml")
}

# Create virtual machine
resource "azurerm_linux_virtual_machine" "gis_vm1" {
  name                  = "${var.gisPrefix}vm1"
  location              = azurerm_resource_group.rg.location
  resource_group_name   = azurerm_resource_group.rg.name
  network_interface_ids = [azurerm_network_interface.gis_nic1.id]
  size                  = var.vmSize

  os_disk {
    name                 = "${var.gisPrefix}OsDisk1"
    caching              = "ReadWrite"
    storage_account_type = "Standard_LRS"
  }

  source_image_reference {
    publisher = "Canonical"
    offer     = "UbuntuServer"
    sku       = "18.04-LTS"
    version   = "latest"
  }

  computer_name                   = "${var.gisPrefix}vm1"
  admin_username                  = "azureuser"
  admin_password                  = "someSecurePass!123"
  disable_password_authentication = false
  user_data                       = data.template_file.gis_user_data.rendered

  admin_ssh_key {
    username   = "azureuser"
    public_key = tls_private_key.gis_ssh1.public_key_openssh
  }
}

#################### / vm gis ####################

#################### vm db ####################
# Create network interface
resource "azurerm_network_interface" "db_nic1" {
  name                = "${var.dbPrefix}nic"
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name

  ip_configuration {
    name                          = "my_nic_configuration"
    subnet_id                     = azurerm_subnet.workloadSubnet.id
    private_ip_address_allocation = "Dynamic"
  }
}

data "template_file" "ds_user_data" {
  template = filebase64("./cloud-init_ds.yaml")
}

# Create (and display) an SSH key
resource "tls_private_key" "db_ssh1" {
  algorithm = "RSA"
  rsa_bits  = 4096
}

# Create virtual machine
resource "azurerm_linux_virtual_machine" "db_vm1" {
  name                  = "${var.dbPrefix}vm1"
  location              = azurerm_resource_group.rg.location
  resource_group_name   = azurerm_resource_group.rg.name
  network_interface_ids = [azurerm_network_interface.db_nic1.id]
  size                  = var.vmSize

  os_disk {
    name                 = "${var.dbPrefix}OsDisk1"
    caching              = "ReadWrite"
    storage_account_type = "Standard_LRS"
  }

  source_image_reference {
    publisher = "Canonical"
    offer     = "UbuntuServer"
    sku       = "18.04-LTS"
    version   = "latest"
  }

  computer_name                   = "${var.dbPrefix}vm1"
  admin_username                  = "azureuser"
  admin_password                  = "someSecurePass!123"
  disable_password_authentication = false
  user_data                       = data.template_file.ds_user_data.rendered

  admin_ssh_key {
    username   = "azureuser"
    public_key = tls_private_key.db_ssh1.public_key_openssh
  }
}

#################### / vm db ####################