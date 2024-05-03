terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
    }
  }
    backend "azurerm" {
    resource_group_name  = "rg-terraform-state-01"
    storage_account_name = "tfstate8399"
    container_name       = "basic-lz-02"
    key                  = "terraform.tfstate"
  }
}


provider "azurerm" {
  features {}
  
}

module "hub_and_spoke" {
  source               = "azurerm/resources/azure//modules/pattern_hub_and_spoke"
  location             = "eastus"
  firewall             = false
  gateway              = false
  bastion              = false
  address_space_hub    = ["10.100.0.0/24"]
  address_space_spokes = [
    {
      workload      = "app1"
      environment   = "dev"
      instance      = "001"
      address_space = ["10.100.10.0/24"]
      virtual_machine = true
      linux_virtual_machine = 5
      windows_virtual_machine = 0
    },
    {
      workload      = "app1"
      environment   = "prd"
      instance      = "001"
      address_space = ["10.100.11.0/24"]
       virtual_machine = false
    }
  ]
}
