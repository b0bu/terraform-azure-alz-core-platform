locals {
  empty_map = {}
  management_groups = {
    root         = ["MyOrg"]
    organisation = ["Platform", "Landing zones", "Decommissioned", "Sandbox"]
    platform     = ["Identity", "Management", "Connectivity"]
    landingzone  = ["Corp", "Online"]
  }
}

data "azurerm_client_config" "core" {}

// org root level 1 created under "Tenant Root Group" when no parent_id provided
// can remove myorg from all of the module names
module "myorg_root_management_group" {
  source            = "../terraform-azure-alz-management-group"
  management_groups = local.management_groups["root"]

  providers = {
    azurerm = azurerm
  }
}

// data model generation of custom and built in policy for archetype platform wide policy maintains independent versioning
module "myorg_root_management_group_policy_factory" {
  source    = "../terraform-azure-alz-core-platform-management-group-policy-factory"
  scope     = module.myorg_root_management_group.parent_ids["MyOrg"]
  archetype = "root"
}

// create custom policy definitions returning their ids
module "myorg_root_management_group_policy_definitions" {
  source              = "../terraform-azure-alz-core-platform-management-group-policy-definitions"
  management_group_id = module.myorg_root_management_group.parent_ids["MyOrg"]
  policy_definitions  = module.myorg_root_management_group_policy_factory.definitions
  providers = {
    azurerm = azurerm
  }
}

// create custom policy initiatives and definitions returning their ids
// should there be a module for initiatives and a module for definitions??
module "myorg_root_management_group_policy_initiatives" {
  source              = "../terraform-azure-alz-core-platform-management-group-policy-initiatives"
  management_group_id = module.myorg_root_management_group.parent_ids["MyOrg"]
  policy_initiatives  = module.myorg_root_management_group_policy_factory.initiatives
  providers = {
    azurerm = azurerm
  }
  depends_on = [
    module.myorg_root_management_group_policy_definitions
  ]
}

// assign builtin policy
module "myorg_root_management_group_builtin_policy_assigment" {
  source              = "../terraform-azure-alz-core-platform-management-group-policy-assignment"
  management_group_id = module.myorg_root_management_group.parent_ids["MyOrg"]
  policy_ids          = module.myorg_root_management_group_policy_factory.builtin_policy

  providers = {
    azurerm = azurerm
  }
}

// assign custom built policies -- add here that it's custom initiaives
module "myorg_root_management_group_custom_policy_assigment" {
  source              = "../terraform-azure-alz-core-platform-management-group-policy-assignment"
  management_group_id = module.myorg_root_management_group.parent_ids["MyOrg"]
  policy_ids          = module.myorg_root_management_group_policy_initiatives.deployed_initiatives

  providers = {
    azurerm = azurerm
  }
}

module "myorg_root_management_group_custom_definition_policy_assigment" {
  source              = "../terraform-azure-alz-core-platform-management-group-policy-assignment"
  management_group_id = module.myorg_root_management_group.parent_ids["MyOrg"]
  policy_ids          = module.myorg_root_management_group_policy_definitions.deployed_definitions

  providers = {
    azurerm = azurerm
  }
}

// policy-factory should know which roles a particular policy needs, that's one of it's purposes
# output "identities" {
#   value = module.myorg_root_management_group_custom_policy_assigment.principal_ids
# }

// which roles belong to which policies and at which scope
# module "myorg_root_management_group_policy_role_assignment" {
#   source     = "../terraform-azure-alz-role-assignment-for-policy"
#   principals = module.myorg_root_management_group_custom_policy_assigment.principal_ids
#   //policy_roles        = module.myorg_root_management_group_policy.azurerm_role_assignments
# }

// required by caf tbd

// data model generation of custom and built in policy for archetype platform wide policy maintains independent versioning
# module "management_management_group_policy_factory" {
#   source    = "../terraform-azure-alz-core-platform-management-group-policy-factory"
#   scope     = module.myorg_root_management_group.parent_ids["Management"]
#   archetype = "management"
# }

// assign custom policy USE SOME OUTPUT FROM CREATE POLICY??
# module "myorg_root_management_group_custom_policy_assigment" {
#   source              = "../terraform-azure-alz-core-platform-management-group-policy-assignment"
#   management_group_id = module.myorg_root_management_group.parent_ids["MyOrg"]
#   policy_initiatives  = module.myorg_root_management_group_policy_factory.initiatives
#   policy_definitions  = module.myorg_root_management_group_policy_factory.definition
#   providers = {
#     azurerm = azurerm
#   }
# }

// ? 
# module "myorg_root_management_group_policy_role_assigment" {
#   source              = "../terraform-azure-alz-core-platform-management-group-policy-assignment"
#   management_group_id = module.myorg_root_management_group.parent_ids["MyOrg"]
#   policy_initiatives  = module.myorg_root_management_group_policy_factory.initiatives
#   policy_definitions  = module.myorg_root_management_group_policy_factory.definition
#   providers = {
#     azurerm = azurerm
#   }
# }

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


// data model returns management level policies
# module "management_management_groups_policy_factory" {
#   source = "../terraform-azure-alz-core-platform-management-group-policy-factory"
#   //version = 0.0.1
#   archetype = "management"
# }

# module "platform_management_groups_management_policy_assignment" {
#   source              = "../terraform-azure-alz-core-platform-management-group-policy-assignment"
#   management_group_id = module.platform_management_groups.parent_ids["Management"]
#   baseline_policy     = module.management_management_groups_policy_factory.baseline_policy
#   custom_policy       = module.management_management_groups_policy_factory.custom_policy

#   providers = {
#     azurerm = azurerm
#   }
# }


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

// ---- law for testing MDFC policy assignment 

module "log_analytics_resource_group" {
  source   = "../terraform-azure-alz-resource-group"
  name     = "testing-law-MDFC-assignment"
  location = "uksouth"
  providers = {
    azurerm = azurerm.sandbox
  }
}

module "log_analytics_workspace" {
  source   = "../terraform-azure-alz-loganalytics-workspace"
  name     = module.log_analytics_resource_group.name
  location = module.log_analytics_resource_group.location

  providers = {
    azurerm = azurerm.sandbox
  }
}