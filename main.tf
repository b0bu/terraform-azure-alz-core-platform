data "azurerm_client_config" "core" {}

// created under "Tenant Root Group" when no parent_id provided
// org root level 1
module "myorg_root_management_group" {
  source            = "../terraform-azure-alz-management-group"
  management_groups = ["MyOrg"]

  providers = {
    azurerm = azurerm
  }
}

module "myorg_root_management_group_policy" {
  source               = "../terraform-azure-alz-core-platform-policy"
  management_group_ids = module.myorg_root_management_group.parent_ids

  providers = {
    azurerm = azurerm
  }
}

// roots for level 2
module "organisational_management_groups" {
  source            = "../terraform-azure-alz-management-group"
  management_groups = ["Platform", "Landing zones", "Decommissioned", "Sandbox"]
  parent_id         = module.myorg_root_management_group.parent_ids["MyOrg"]

  providers = {
    azurerm = azurerm
  }
}

module "organisational_management_groups_policy" {
  source               = "../terraform-azure-alz-core-platform-policy"
  management_group_ids = module.organisational_management_groups.parent_ids

  providers = {
    azurerm = azurerm
  }
}

// roots for level 3
module "platform_management_groups" {
  source            = "../terraform-azure-alz-management-group"
  management_groups = ["Identity", "Management", "Connectivity"]
  parent_id         = module.organisational_management_groups.parent_ids["Platform"]

  providers = {
    azurerm = azurerm
  }
}

module "platform_management_groups_policy" {
  source               = "../terraform-azure-alz-core-platform-policy"
  management_group_ids = module.platform_management_groups.parent_ids

  providers = {
    azurerm = azurerm
  }
}

// secondary roots for level 3
module "application_management_groups" {
  source            = "../terraform-azure-alz-management-group"
  management_groups = ["Corp", "Online"]
  parent_id         = module.organisational_management_groups.parent_ids["Landing zones"]

  providers = {
    azurerm = azurerm
  }
}

module "application_management_groups_policy" {
  source               = "../terraform-azure-alz-core-platform-policy"
  management_group_ids = module.application_management_groups.parent_ids

  providers = {
    azurerm = azurerm
  }
}