locals {
  empty_map    = {}
  management_groups = {
    root         = ["MyOrg"]
    organisation = ["Platform", "Landing zones", "Decommissioned", "Sandbox"]
    platform     = ["Identity", "Management", "Connectivity"]
    landingzone  = ["Corp", "Online"]
  }
}

data "azurerm_client_config" "core" {}

// org root level 1 created under "Tenant Root Group" when no parent_id provided
module "myorg_root_management_group" {
  source            = "../terraform-azure-alz-management-group"
  management_groups = local.management_groups["root"]

  providers = {
    azurerm = azurerm
  }
}

// data model returns root level management group policies
module "myorg_root_management_group_policy_factory" {
  source = "../terraform-azure-alz-core-platform-management-group-policy-factory"
  //version = 0.0.1
  archetype = "root"
}

module "myorg_root_management_group_policy_assigment" {
  source              = "../terraform-azure-alz-core-platform-management-group-policy-assignment"
  management_group_id = module.myorg_root_management_group.parent_ids["MyOrg"]
  baseline_policy     = module.myorg_root_management_group_policy_factory.baseline_policy
  custom_policy       = module.myorg_root_management_group_policy_factory.custom_policy

  providers = {
    azurerm = azurerm
  }
}

// -------------------

// roots for level 2 of hierarchy, also defined decomissioned and sandboxes but are not in use right now
module "organisational_management_groups" {
  source            = "../terraform-azure-alz-management-group"
  management_groups = local.management_groups["organisation"]
  parent_id         = module.myorg_root_management_group.parent_ids["MyOrg"]

  providers = {
    azurerm = azurerm
  }
}

// data model returns platform level policies
module "platform_management_groups_policy_factory" {
  source = "../terraform-azure-alz-core-platform-management-group-policy-factory"
  //version = 0.0.1
  archetype = "platform"
}

module "organisational_management_group_platform_policy_assignment" {
  source              = "../terraform-azure-alz-core-platform-management-group-policy-assignment"
  management_group_id = module.organisational_management_groups.parent_ids["Platform"]
  baseline_policy     = module.platform_management_groups_policy_factory.baseline_policy
  custom_policy       = module.platform_management_groups_policy_factory.custom_policy

  providers = {
    azurerm = azurerm
  }
}

// data model returns landingzone level policies
module "landingzones_management_groups_policy_factory" {
  source = "../terraform-azure-alz-core-platform-management-group-policy-factory"
  //version = 0.0.1
  archetype = "landingzones"
}

module "organisational_management_group_landingzones_policy_assignment" {
  source              = "../terraform-azure-alz-core-platform-management-group-policy-assignment"
  management_group_id = module.organisational_management_groups.parent_ids["Landing zones"]
  baseline_policy     = module.landingzones_management_groups_policy_factory.baseline_policy
  custom_policy       = module.landingzones_management_groups_policy_factory.custom_policy

  providers = {
    azurerm = azurerm
  }
}

// -------------------

// roots for level 3
module "platform_management_groups" {
  source            = "../terraform-azure-alz-management-group"
  management_groups = local.management_groups["platform"]
  parent_id         = module.organisational_management_groups.parent_ids["Platform"]

  providers = {
    azurerm = azurerm
  }
}

// data model returns identity level policies
module "identity_management_groups_policy_factory" {
  source = "../terraform-azure-alz-core-platform-management-group-policy-factory"
  //version = 0.0.1
  archetype = "identity"
}


module "platform_management_groups_identity_policy_assignment" {
  source              = "../terraform-azure-alz-core-platform-management-group-policy-assignment"
  management_group_id = module.platform_management_groups.parent_ids["Identity"]
  baseline_policy     = module.identity_management_groups_policy_factory.baseline_policy
  custom_policy       = module.identity_management_groups_policy_factory.custom_policy

  providers = {
    azurerm = azurerm
  }
}

// data model returns management level policies
module "management_management_groups_policy_factory" {
  source = "../terraform-azure-alz-core-platform-management-group-policy-factory"
  //version = 0.0.1
  archetype = "management"
}

module "platform_management_groups_management_policy_assignment" {
  source              = "../terraform-azure-alz-core-platform-management-group-policy-assignment"
  management_group_id = module.platform_management_groups.parent_ids["Management"]
  baseline_policy     = module.management_management_groups_policy_factory.baseline_policy
  custom_policy       = module.management_management_groups_policy_factory.custom_policy

  providers = {
    azurerm = azurerm
  }
}

module "connectivity_management_groups_policy_factory" {
  source = "../terraform-azure-alz-core-platform-management-group-policy-factory"
  //version = 0.0.1
  archetype = "connectivity"
}


module "platform_management_groups_connectivity_policy_assignment" {
  source              = "../terraform-azure-alz-core-platform-management-group-policy-assignment"
  management_group_id = module.platform_management_groups.parent_ids["Connectivity"]
  baseline_policy     = module.connectivity_management_groups_policy_factory.baseline_policy
  custom_policy       = module.connectivity_management_groups_policy_factory.custom_policy

  providers = {
    azurerm = azurerm
  }
}


// -------------------

// secondary level 3 roots
module "application_management_groups" {
  source            = "../terraform-azure-alz-management-group"
  management_groups = local.management_groups["landingzone"]
  parent_id         = module.organisational_management_groups.parent_ids["Landing zones"]

  providers = {
    azurerm = azurerm
  }
}

// data model returns corp level policies
module "corp_management_groups_policy_factory" {
  source = "../terraform-azure-alz-core-platform-management-group-policy-factory"
  //version = 0.0.1
  archetype = "corp"
}

module "application_management_groups_corp_policy_assignment" {
  source              = "../terraform-azure-alz-core-platform-management-group-policy-assignment"
  management_group_id = module.application_management_groups.parent_ids["Corp"]
  baseline_policy     = module.corp_management_groups_policy_factory.baseline_policy
  custom_policy       = module.corp_management_groups_policy_factory.custom_policy

  providers = {
    azurerm = azurerm
  }
}

// data model returns online level policies
module "online_management_groups_policy_factory" {
  source = "../terraform-azure-alz-core-platform-management-group-policy-factory"
  //version = 0.0.1
  archetype = "online"
}

module "application_management_groups_online_policy_assignment" {
  source              = "../terraform-azure-alz-core-platform-management-group-policy-assignment"
  management_group_id = module.application_management_groups.parent_ids["Online"]
  baseline_policy     = module.online_management_groups_policy_factory.baseline_policy
  custom_policy       = module.online_management_groups_policy_factory.custom_policy

  providers = {
    azurerm = azurerm
  }
}