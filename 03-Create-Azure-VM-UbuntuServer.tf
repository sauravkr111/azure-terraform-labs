# Define the provider and configure the Azure environment
provider "azurerm" {
  features {}
}

# Define a resource group
resource "azurerm_resource_group" "saurav" {
  name     = "saurav-resources"
  location = "East US"
}

# Define a virtual network
resource "azurerm_virtual_network" "saurav_vnet" {
  name                = "saurav-vnet"
  address_space       = ["10.0.0.0/16"]
  location            = azurerm_resource_group.saurav.location
  resource_group_name = azurerm_resource_group.saurav.name
}

# Define a subnet
resource "azurerm_subnet" "saurav_subnet" {
  name                 = "saurav-subnet"
  resource_group_name  = azurerm_resource_group.saurav.name
  virtual_network_name = azurerm_virtual_network.saurav_vnet.name
  address_prefixes     = ["10.0.1.0/24"]
}

# Define a public IP address
resource "azurerm_public_ip" "saurav_public_ip" {
  name                = "saurav-public-ip"
  location            = azurerm_resource_group.saurav.location
  resource_group_name = azurerm_resource_group.saurav.name
  allocation_method   = "Dynamic"
}

# Define a network interface
resource "azurerm_network_interface" "saurav_nic" {
  name                = "saurav-nic"
  location            = azurerm_resource_group.saurav.location
  resource_group_name = azurerm_resource_group.saurav.name

  ip_configuration {
    name                          = "saurav-ip-config"
    subnet_id                     = azurerm_subnet.saurav_subnet.id
    private_ip_address_allocation = "Dynamic"
    public_ip_address_id          = azurerm_public_ip.saurav_public_ip.id
  }
}

# Define a virtual machine
resource "azurerm_virtual_machine" "saurav_vm" {
  name                  = "saurav-vm"
  location              = azurerm_resource_group.saurav.location
  resource_group_name   = azurerm_resource_group.saurav.name
  network_interface_ids = [azurerm_network_interface.saurav_nic.id]
  vm_size               = "Standard_DS1_v2"

  # Provide the details for the virtual machine's OS disk
  storage_os_disk {
    name              = "saurav-os-disk"
    caching           = "ReadWrite"
    create_option     = "FromImage"
    managed_disk_type = "Standard_LRS"
  }

  # Define the OS profile
  os_profile {
    computer_name  = "sauravvm"
    admin_username = "sauravadmin"
    admin_password = "OMITTED" # Change this to a secure password
  }

  # Define the OS profile for Linux-based VMs
  os_profile_linux_config {
    disable_password_authentication = false
  }

  # Define the source image for the virtual machine
  storage_image_reference {
    publisher = "Canonical"
    offer     = "UbuntuServer"
    sku       = "18.04-LTS"
    version   = "latest"
  }
}
