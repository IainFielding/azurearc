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
  name     = "azdemo-uks-rg-arcsvc"                                   # This is the name of the Resource Group for the Azure ARC Service
  location = "uksouth"                                                # This is the region the service will be delployed in to  
  tags     = var.tags
}

# Resource group for servers to be added to 
resource "azurerm_resource_group" "arc-servers-rg" {
  name     = "azdemo-uks-rg-arc-servers"                                   # This is the name of the Resource Group for the Azure ARC Servers
  location = "uksouth"                                                # This is the region the service will be delployed in to  
  tags     = var.tags
}

resource "azurerm_arc_private_link_scope" "demo-arc-pls" {
  name                          = "azdemo-uks-pls-arc01"
  resource_group_name           = azurerm_resource_group.arcsvc-rg.name
  location                      = azurerm_resource_group.arcsvc-rg.location
  public_network_access_enabled = false
  tags                          = var.tags
}

# Builds the Private endpoint for the Azure ARC Service
resource "azurerm_private_endpoint" "arc-pe" {
  name                = "azdemo-uks-ple-arc01"       # this is the name of the Private EndPoint
  location            = azurerm_resource_group.arcsvc-rg.location
  resource_group_name = azurerm_resource_group.arcsvc-rg.name
  subnet_id           = data.azurerm_subnet.subnet.id

  private_service_connection {
    name                           = "azdemo-uks-psc-arc01"    # This is the name of the private service connection
    private_connection_resource_id = azurerm_arc_private_link_scope.demo-arc-pls.id
    is_manual_connection           = false
    subresource_names              = ["hybridcompute"]
    }
    tags = var.tags
# Ignore, because managed by DeployIfNotExists policy 
  lifecycle {
    ignore_changes = [
      private_dns_zone_group,
      network_interface        
    ]
  }
  }
