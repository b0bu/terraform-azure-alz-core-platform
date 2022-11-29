terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = ">= 3.0.2"
    }
  }
}

provider "azurerm" {
  features {}
}

data "azurerm_client_config" "core" {}

// created under "Tenant Root Group" when no parent_id provided
module "level_1" {
  source            = "../terraform-azure-alz-management-group"
  management_groups = ["MyOrg"]
}

module "level_2" {
  source = "../terraform-azure-alz-management-group"
  management_groups = [
    "Platform",
    "Landing zones",
    "Decommissioned",
    "Sandbox"
  ]
  parent_id = module.level_1.parent_id["MyOrg"]
  depends_on = [module.level_1]
}

module "level_3_platform" {
  source = "../terraform-azure-alz-management-group"
  management_groups = [
    "Identity",
    "Management",
    "Connectivity",
  ]
  parent_id = module.level_2.parent_id["Platform"]
  depends_on = [module.level_2]
}

module "level_3_landingzone" {
  source = "../terraform-azure-alz-management-group"
  management_groups = [
    "Corp",
    "Online",
  ]
  parent_id = module.level_2.parent_id["Landing zones"]
  depends_on = [module.level_2]
}