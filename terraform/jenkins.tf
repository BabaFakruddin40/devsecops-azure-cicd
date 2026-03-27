# Virtual Machine for Jenkins
resource "azurerm_virtual_network" "vnet" {
  name                = "devsecops-vnet"
  address_space       = ["10.0.0.0/16"]
  location            = azurerm_resource_group.devsecops.location
  resource_group_name = azurerm_resource_group.devsecops.name
}

resource "azurerm_subnet" "jenkins_subnet" {
  name                 = "jenkins-subnet"
  resource_group_name  = azurerm_resource_group.devsecops.name
  virtual_network_name = azurerm_virtual_network.vnet.name
  address_prefixes     = ["10.0.1.0/24"]
}

resource "azurerm_public_ip" "jenkins_ip" {
  name                = "jenkins-pip"
  location            = azurerm_resource_group.devsecops.location
  resource_group_name = azurerm_resource_group.devsecops.name
  allocation_method   = "Static"
  sku                 = "Standard"
}

resource "azurerm_network_interface" "jenkins_nic" {
  name                = "jenkins-nic"
  location            = azurerm_resource_group.devsecops.location
  resource_group_name = azurerm_resource_group.devsecops.name

  ip_configuration {
    name                          = "jenkins-ip-config"
    subnet_id                     = azurerm_subnet.jenkins_subnet.id
    private_ip_address_allocation = "Dynamic"
    public_ip_address_id          = azurerm_public_ip.jenkins_ip.id
  }
}

resource "azurerm_network_security_group" "jenkins_nsg" {
  name                = "jenkins-nsg"
  location            = azurerm_resource_group.devsecops.location
  resource_group_name = azurerm_resource_group.devsecops.name

  security_rule {
    name                       = "AllowHTTP"
    priority                   = 100
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "8080"
    source_address_prefix      = "*"
    destination_address_prefix = "*"
  }

  security_rule {
    name                       = "AllowSSH"
    priority                   = 101
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "22"
    source_address_prefix      = "*"
    destination_address_prefix = "*"
  }
}

resource "azurerm_network_interface_security_group_association" "jenkins_nsg_assoc" {
  network_interface_id      = azurerm_network_interface.jenkins_nic.id
  network_security_group_id = azurerm_network_security_group.jenkins_nsg.id
}

resource "azurerm_linux_virtual_machine" "jenkins" {
  name                = "jenkins-vm"
  location            = azurerm_resource_group.devsecops.location
  resource_group_name = azurerm_resource_group.devsecops.name
  size                = "Standard_B2s"

  admin_username = "azureuser"

  admin_ssh_key {
    username   = "azureuser"
    public_key = file(var.ssh_public_key_path)
  }

  os_disk {
    caching              = "ReadWrite"
    storage_account_type = "Premium_LRS"
  }

  source_image_reference {
    publisher = "Canonical"
    offer     = "0001-com-ubuntu-server-focal"
    sku       = "20_04-lts-gen2"
    version   = "latest"
  }

  user_data = base64encode(file("${path.module}/../jenkins/jenkins-setup.sh"))

  network_interface_ids = [
    azurerm_network_interface.jenkins_nic.id,
  ]

  tags = {
    Environment = var.environment
  }
}