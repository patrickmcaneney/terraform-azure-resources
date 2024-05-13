terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
    }
  }
    backend "azurerm" {
    resource_group_name  = "rg-terraform-state-01"
    storage_account_name = "tfstate8399"
    container_name       = "basic-lz-github02"
    key                  = "terraform.tfstate"
  }
}


provider "azurerm" {
  features {}
  
}

module "hub_and_spoke" {
  source                                 = "azurerm/resources/azure//modules/pattern_hub_and_spoke"
  location                               = "eastus"
  firewall                               = true
  gateway                                = false
  bastion                                = false
  address_space_hub                      = ["10.100.0.0/24"]
  spoke_dns                              = true
  address_space_spoke_dns                = ["10.100.1.0/24"]
  spoke_dmz                              = false
  address_space_spoke_dmz                = ["10.100.2.0/24"]
  web_application_firewall               = false
  private_monitoring                     = true
  address_space_spoke_private_monitoring = ["10.100.3.0/27"]
  connection_monitor                     = true
  update_management                      = true
  address_space_spokes = [
    {
      workload        = "shared"
      environment     = "prd"
      instance        = "001"
      address_space   = ["10.100.5.0/24"]
      virtual_machine = false
    },
    {
      workload        = "app1"
      environment     = "dev"
      instance        = "001"
      address_space   = ["10.100.10.0/24"]
      virtual_machine = false

    }
  ]
}
