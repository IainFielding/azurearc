terraform {
  required_version = ">= 1.5.3"
  backend "azurerm" {}

  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "3.65.0"
    }
    local = {
      source  = "hashicorp/local"
      version = "2.4.0"
    }
    null = {
      source  = "hashicorp/null"
      version = "3.2.1"
    }
    azapi = {
      source  = "Azure/azapi"
      version = "1.7.0"
    }
    external = {
      source  = "hashicorp/external"
      version = "2.3.1"
    }
  }
}

provider "azurerm" {
  skip_provider_registration = "true"  
  tenant_id       = "010864f4-6b22-4a19-a225-f406ba3e04b8"
  subscription_id = "3fd61fe3-fdc7-4024-8ece-cfd22c4aeafd" 
  features {
  }
}

provider "azapi" {
}

provider "azurerm" {
  alias           = "loggingcore"
  subscription_id = "3fd61fe3-fdc7-4024-8ece-cfd22c4aeafd" 
  features {}
}

provider "azurerm" {
  alias           = "hub"
  subscription_id = "3fd61fe3-fdc7-4024-8ece-cfd22c4aeafd" 
  features {}
}

provider "azurerm" {
  alias           = "dns"
  subscription_id = "3fd61fe3-fdc7-4024-8ece-cfd22c4aeafd" 
  features {}
}

