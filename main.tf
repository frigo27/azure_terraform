
provider "azurerm" {
  version = "~> 2.27.0"
  features {}
}
resource "azurerm_resource_group" "rg" {
  name= "Atividade4"
  location = "eastus2"
  
}

