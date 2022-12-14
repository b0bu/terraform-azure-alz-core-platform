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
// checking of values to be done in the module, sos to make consumption of the module easier
module "myorg_root_management_group_policy_definitions" {
  for_each = module.myorg_root_management_group_policy_factory.definitions

  source       = "../terraform-azure-alz-core-platform-management-group-policy-definitions"
  name         = each.value.name
  mode         = each.value.properties.mode
  display_name = each.value.properties.displayName

  description         = try(each.value.properties.description, "${each.value.name} Policy Definition at scope ${each.value.scope_id}")
  policy_rule         = try(length(each.value.properties.policyRule) > 0, false) ? jsonencode(each.value.properties.policyRule) : null
  metadata            = try(length(each.value.properties.metadata) > 0, false) ? jsonencode(each.value.properties.metadata) : null
  parameters          = try(length(each.value.properties.parameters) > 0, false) ? jsonencode(each.value.properties.parameters) : null
  management_group_id = try(each.value.scope_id, module.myorg_root_management_group.parent_ids["MyOrg"])

  providers = {
    azurerm = azurerm
  }
}

module "myorg_root_management_group_policy_initiatives" {
  for_each = module.myorg_root_management_group_policy_factory.initiatives

  source     = "../terraform-azure-alz-core-platform-management-group-policy-initiatives"
  name       = each.value.name
  properties = each.value.properties

  management_group_id = try(each.value.scope_id, module.myorg_root_management_group.parent_ids["MyOrg"])

  depends_on = [
    module.myorg_root_management_group_policy_definitions
  ]

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

locals {

  policy_assignment_requiring_managed_identity = [
    for _, policy in module.myorg_root_management_group_policy_initiatives :
    policy.deployed_initiative if contains(keys(module.myorg_root_management_group_policy_factory.azurerm_role_assignments), policy.deployed_initiative.name)
  ]

  policy_assignment_not_requiring_managed_identity = [
    for _, policy in module.myorg_root_management_group_policy_initiatives :
    policy.deployed_initiative if !contains(keys(module.myorg_root_management_group_policy_factory.azurerm_role_assignments), policy.deployed_initiative.name)
  ]
}

// dynamic custom policy assignment
module "root_management_group_policy_assigment_not_requiring_managed_identity" {
  for_each            = { for policy in local.policy_assignment_not_requiring_managed_identity : policy.name => policy }
  source              = "../terraform-azure-alz-core-platform-management-group-policy-assignment-no-managed-identity"
  management_group_id = module.myorg_root_management_group.parent_ids["MyOrg"]
  name                = each.value.name
  policy_id           = each.value.id
  parameters          = jsonencode(try(module.myorg_root_management_group_policy_factory.parameters[each.value.name].params, {}))

  providers = {
    azurerm = azurerm
  }
}

module "root_management_group_policy_assigment_requiring_managed_identity" {
  for_each            = { for policy in local.policy_assignment_requiring_managed_identity : policy.name => policy }
  source              = "../terraform-azure-alz-core-platform-management-group-policy-assignment-with-managed-identity"
  management_group_id = module.myorg_root_management_group.parent_ids["MyOrg"]
  name                = each.value.name
  policy_id           = each.value.id
  parameters          = jsonencode(try(module.myorg_root_management_group_policy_factory.parameters[each.value.name].params, {}))

  providers = {
    azurerm = azurerm
  }
}

// static builtin policy assignment no need to create policy only assign
module "root_management_group_builtin_policy_assigment_allowed_locations" {
  source              = "../terraform-azure-alz-core-platform-management-group-policy-assignment-no-managed-identity"
  management_group_id = module.myorg_root_management_group.parent_ids["MyOrg"]
  name                = "Allowed-locations"
  policy_id           = "/providers/Microsoft.Authorization/policyDefinitions/e56962a6-4747-49cd-b67b-bf8b01975c4c"
  parameters          = <<PARAMETERS
  {
    "listOfAllowedLocations":{
        "value": ["uksouth","ukwest","global"]
    }
  }
  PARAMETERS

  providers = {
    azurerm = azurerm
  }
}

// with or without managed id should be managed_identity = true
module "root_management_group_builtin_policy_assigment_nist" {
  source              = "../terraform-azure-alz-core-platform-management-group-policy-assignment-with-managed-identity"
  management_group_id = module.myorg_root_management_group.parent_ids["MyOrg"]
  name                = "NIST-SP-800-53-rev-5"
  policy_id           = "/providers/Microsoft.Authorization/policySetDefinitions/179d1daa-458f-4e47-8086-2a68d0d6c38f"
  //managed_identity    = true

  providers = {
    azurerm = azurerm
  }
}

module "root_management_group_builtin_policy_assigment_cis" {
  source              = "../terraform-azure-alz-core-platform-management-group-policy-assignment-no-managed-identity"
  management_group_id = module.myorg_root_management_group.parent_ids["MyOrg"]
  name                = "CIS-Benchmark-v1.4.0"
  policy_id           = "/providers/Microsoft.Authorization/policySetDefinitions/c3f5c4d9-9a1d-4a99-85c0-7f93e384d5c5"


  providers = {
    azurerm = azurerm
  }
}

// NOW I CARE ABOUT THE PRINCIPAL OUTPUT OF THE ASSIGNMENT FOR THE ROLE

// which roles belong to which policies and at which scope
# module "myorg_root_management_group_policy_role_assignment" {
#   source     = "../terraform-azure-alz-role-assignment-for-policy"
#   principals = module.myorg_root_management_group_custom_policy_assigment.principal_ids
#   //policy_roles        = module.myorg_root_management_group_policy.azurerm_role_assignments
# }

// required by caf tbd there is a policy assignemnt at this scope 

// data model generation of custom and built in policy for archetype platform wide policy maintains independent versioning
# module "management_management_group_policy_factory" {
#   source    = "../terraform-azure-alz-core-platform-management-group-policy-factory"
#   scope     = module.myorg_root_management_group.parent_ids["Management"]
#   archetype = "management"
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

