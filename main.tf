// all root module data structures can be viewed with terraform output
locals {
  management_groups = {
    organisation = ["Platform", "Landing zones", "Decommissioned", "Sandbox"]
    platform     = ["Identity", "Management", "Connectivity"]
    application  = ["Corp", "Online"]
  }
}

data "azurerm_client_config" "core" {}

// created under "Tenant Root Group" when no parent_id provided
module "root_management_group" {
  source       = "../terraform-azure-alz-management-group"
  display_name = "MyOrg"

  providers = {
    azurerm = azurerm
  }
}

// data model generation of custom policy
module "root_management_group_policy_factory" {
  source    = "../terraform-azure-alz-core-platform-management-group-policy-factory"
  scope     = module.root_management_group.id
  archetype = "root"
}

// create the custom policy definitions returning their ids
module "root_management_group_policy_definitions" {
  for_each = module.root_management_group_policy_factory.definitions

  source       = "../terraform-azure-alz-core-platform-management-group-policy-definitions"
  name         = each.value.name
  mode         = each.value.properties.mode
  display_name = each.value.properties.displayName

  description         = try(each.value.properties.description, "${each.value.name} Policy Definition at scope ${each.value.scope_id}")
  policy_rule         = try(length(each.value.properties.policyRule) > 0, false) ? jsonencode(each.value.properties.policyRule) : null
  metadata            = try(length(each.value.properties.metadata) > 0, false) ? jsonencode(each.value.properties.metadata) : null
  parameters          = try(length(each.value.properties.parameters) > 0, false) ? jsonencode(each.value.properties.parameters) : null
  management_group_id = try(each.value.scope_id, module.root_management_group.id)

  providers = {
    azurerm = azurerm
  }
}

locals {
  // overrides for any dummy parameter values used to satisfy the interface; replace with real values here
  overrides = {
    logAnalytics = {
      value = module.log_analytics_workspace.id
    }
  }
  parameters = {
    Deploy-MDFC-Config   = merge(module.root_management_group_policy_factory.parameters["Deploy-MDFC-Config"].params, local.overrides)
    Deploy-Resource-Diag = merge(module.root_management_group_policy_factory.parameters["Deploy-Resource-Diag"].params, local.overrides)
  }
}

// create the custom policy initiatives returning their ids
module "root_management_group_policy_initiatives" {
  for_each = module.root_management_group_policy_factory.initiatives

  source     = "../terraform-azure-alz-core-platform-management-group-policy-initiatives"
  name       = each.value.name
  properties = each.value.properties

  management_group_id = try(each.value.scope_id, module.root_management_group.id)

  depends_on = [
    module.root_management_group_policy_definitions
  ]

  providers = {
    azurerm = azurerm
  }
}

locals {
  // data structure to extract dynamically created custom initiatives and whether they should have a managed identity set or not
  managed_identity_policy_assignments = [
    for file in module.root_management_group_policy_factory.list_of_policy_initiative_file_names : {
      name             = module.root_management_group_policy_initiatives[file].deployed_initiative.name
      id               = module.root_management_group_policy_initiatives[file].deployed_initiative.id
      display_name     = module.root_management_group_policy_initiatives[file].deployed_initiative.display_name
      description      = module.root_management_group_policy_initiatives[file].deployed_initiative.description
      managed_identity = contains(keys(module.root_management_group_policy_factory.managed_identity_role_assignments), module.root_management_group_policy_initiatives[file].deployed_initiative.name) ? true : false
    }
  ]
}

// dynamic custom policy assignment, terraform must know any map's key at apply time for addressing purposes using index keeps this deterministic
// rename this to root_management_group_initiative_assigment
module "root_management_group_policy_assigment" {
  for_each            = { for index, policy in local.managed_identity_policy_assignments : index => policy }
  source              = "../terraform-azure-alz-core-platform-management-group-policy-assignment"
  management_group_id = module.root_management_group.id
  name                = each.value.name
  policy_id           = each.value.id
  display_name        = each.value.display_name
  description         = each.value.description
  // use local.parameter overrides if set else use policy factory module output paramaters
  parameters          = contains(keys(local.parameters), each.value.name) ? jsonencode(local.parameters[each.value.name]) : jsonencode(try(module.root_management_group_policy_factory.parameters[each.value.name].params, null))
  managed_identity    = each.value.managed_identity

  depends_on = [
    module.root_management_group_policy_initiatives
  ]

  providers = {
    azurerm = azurerm
  }
}

locals {
  // data structure to extract dynamically determined policy identity created at runtime, and map to a policy name
  managed_identity_principal_ids = {
    for _, policy in module.root_management_group_policy_assigment :
    (policy.assignment.name) => policy.assignment.identity[0].principal_id
    if contains(keys(module.root_management_group_policy_factory.managed_identity_role_assignments), policy.assignment.name)
  }

  // data structure for applying role assignments for above managed identities
  managed_identity_policy_assignment_roles = [
    for policy_name, roles in module.root_management_group_policy_factory.managed_identity_role_assignments : {
      for role_name in roles :
      "${policy_name}-${role_name}" => {
        policy_name  = policy_name
        role_name    = role_name
        principal_id = local.managed_identity_principal_ids[policy_name]
      }
      // if removes empty {} from object
    } if length(roles) > 0
  ]
}

// role assignment for policy dynamically generated policy
// rename this to root_management_group_role_assignment_for_initiative_assignment_managed_identitities
module "root_management_group_role_assignment_for_policy_assignment_managed_identitities" {
  for_each     = local.managed_identity_policy_assignment_roles[0]
  source       = "../terraform-azure-alz-role-assignment"
  principal_id = each.value.principal_id
  role_name    = each.value.role_name
  scope        = module.root_management_group.id

  providers = {
    azurerm = azurerm
  }
}

// required by caf tbd there is a policy assignemnt at this scope 

// data model generation of custom and built in policy for archetype platform wide policy maintains independent versioning
# module "management_management_group_policy_factory" {
#   source    = "../terraform-azure-alz-core-platform-management-group-policy-factory"
#   scope     = module.root_management_group.parent_ids["Management"]
#   archetype = "management"
# }

// -------------------

// roots for level 2 of hierarchy, also defined decomissioned and sandboxes but are not in use right now
module "organisational_management_groups" {
  for_each     = toset(local.management_groups.organisation)
  source       = "../terraform-azure-alz-management-group"
  display_name = each.value
  parent_id    = module.root_management_group.id

  providers = {
    azurerm = azurerm
  }
}

// -------------------

// roots for level 3
module "platform_management_groups" {
  for_each     = toset(local.management_groups.platform)
  source       = "../terraform-azure-alz-management-group"
  display_name = each.value
  parent_id    = module.organisational_management_groups["Platform"].id

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
  for_each     = toset(local.management_groups.application)
  source       = "../terraform-azure-alz-management-group"
  display_name = each.value
  parent_id    = module.organisational_management_groups["Landing zones"].id

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