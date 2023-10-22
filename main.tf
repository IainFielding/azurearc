#Variables
variable "tags" {
  description = "A mapping of tags to assign to the resource."
  type = object({
    Environment  = string
    BusinessUnit = string
    Owner        = string
    AppID        = string
    CostCentre   = string
    Criticality  = string
  })
}

# Data Section

data "azurerm_resource_group" "vnet-rg" {
  name = "VNET" # This is the Resource group for the vnet
}

data "azurerm_virtual_network" "vnet" {
  name                = "lz-vnet-01"  # This is the name of the VNET
  resource_group_name = data.azurerm_resource_group.vnet-rg.name
}

data "azurerm_subnet" "subnet" {
  name                 = "subnet-5"  # This is the name of the subnet that the private endpoint will be installed in to
  virtual_network_name = data.azurerm_virtual_network.vnet.name
  resource_group_name  = data.azurerm_resource_group.vnet-rg.name
}


# Resource group for arc private endpoint
resource "azurerm_resource_group" "arcsvc-rg" {
  name     = "azdemo-uks-rg-arcsvc"                                   # This is the name of the Resource Group for the cognitive Service
  location = "uksouth"                                                # This is the region the service will be delployed in to  
  tags     = var.tags
}

# Resource group for servers to be added to 
resource "azurerm_resource_group" "arc-servers-rg" {
  name     = "azdemo-uks-rg-arc-servers"                                   # This is the name of the Resource Group for the cognitive Service
  location = "uksouth"                                                # This is the region the service will be delployed in to  
  tags     = var.tags
}


