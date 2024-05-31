# Define the provider and configure the Azure environment
provider "azurerm" {
  features {}
}

# Define a resource group
resource "azurerm_resource_group" "example" {
  name     = "example-resources"
  location = "East US"
}
