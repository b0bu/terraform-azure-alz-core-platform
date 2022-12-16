module "root_management_group_builtin_policy_assigment_allowed_locations" {
  source              = "../terraform-azure-alz-core-platform-management-group-policy-assignment"
  management_group_id = module.root_management_group.id
  name                = "AllowedLocations"
  display_name        = "Allowed locations"
  description         = "This policy enables you to restrict the locations your organisation can specify when depliying resources. Use to enforce your geo-compliance requirements. Excludes resource groups, Microsoft.AzureActiveDirectory/b2bDirectories, and resource that use the 'global' region"
  policy_id           = "/providers/Microsoft.Authorization/policyDefinitions/e56962a6-4747-49cd-b67b-bf8b01975c4c"
  parameters          = <<PARAMETERS
  {
    "listOfAllowedLocations":{
        "value": ["uksouth","ukwest","global"]
    }
  }
  PARAMETERS
  managed_identity    = false

  providers = {
    azurerm = azurerm
  }
}

module "root_management_group_builtin_policy_assigment_nist" {
  source              = "../terraform-azure-alz-core-platform-management-group-policy-assignment"
  management_group_id = module.root_management_group.id
  name                = "NIST-SP-800-53-rev-5"
  display_name        = "NIST SP 800-53 Rev. 5"
  description         = "National Institute of Standards and Technology (NIST) SP 800-53 Rev. 5 provides a standardized approach for assessing, monitoring and authorizing cloud computing products and services to manage information security risk. These policies address a subset of NIST SP 800-53 R5 controls. Additional policies will be added in upcoming releases. For more information, visit https://aka.ms/nist800-53r5-initiative"
  policy_id           = "/providers/Microsoft.Authorization/policySetDefinitions/179d1daa-458f-4e47-8086-2a68d0d6c38f"
  managed_identity    = true

  providers = {
    azurerm = azurerm
  }
}

module "root_management_group_builtin_policy_assigment_cis" {
  source              = "../terraform-azure-alz-core-platform-management-group-policy-assignment"
  management_group_id = module.root_management_group.id
  name                = "CIS-Benchmark-v1.4.0"
  display_name        = "CIS Microsoft Azure Foundations Benchmark v1.4.0"
  description         = "The Center for Internet Security (CIS) is a nonprofit entity whose mission is to 'identify, develop, validate, promote, and sustain best practice solutions for cyberdefense.' CIS benchmarks are configuration baselines and best practices for securely configuring a system. These policies address a subset of CIS Microsoft Azure Foundations Benchmark v1.4.0 controls. For more information, visit https://aka.ms/cisazure130-initiative"
  policy_id           = "/providers/Microsoft.Authorization/policySetDefinitions/c3f5c4d9-9a1d-4a99-85c0-7f93e384d5c5"
  managed_identity    = false

  providers = {
    azurerm = azurerm
  }
}

module "root_management_group_builtin_policy_allowed_locations_for_rg" {
  source              = "../terraform-azure-alz-core-platform-management-group-policy-assignment"
  management_group_id = module.root_management_group.id
  name                = "AllowedLocationsForRg"
  display_name        = "Allowed locations for resource groups"
  description         = "This policy enables you to restrict the locations your organization can create resource groups in. Use to enforce your geo-compliance requirements."
  policy_id           = "/providers/Microsoft.Authorization/policyDefinitions/e765b5de-1225-4ba3-bd56-1ac6695af988"
  parameters          = <<PARAMETERS
  {
    "listOfAllowedLocations":{
        "value": ["uksouth","ukwest","global"]
    }
  }
  PARAMETERS
  managed_identity    = false

  providers = {
    azurerm = azurerm
  }
}

module "root_management_group_builtin_policy_inherit_project_tag_from_rg" {
  source              = "../terraform-azure-alz-core-platform-management-group-policy-assignment"
  management_group_id = module.root_management_group.id
  name                = "InheritProjectTagRg"
  display_name        = "Inherit Project tag from the resource group if missing"
  description         = "Adds the specified tag with its value from the parent resource group when any resource missing this tag is created or updated. Existing resources can be remediated by triggering a remediation task. If the tag exists with a different value it will not be changed."
  policy_id           = "/providers/Microsoft.Authorization/policyDefinitions/ea3f2387-9b95-492a-a190-fcdc54f7b070"
  parameters          = <<PARAMETERS
  {
    "tagName":{
        "value": "Project"
    }
  }
  PARAMETERS
  managed_identity    = true

  providers = {
    azurerm = azurerm
  }
}

module "root_management_group_builtin_policy_inherit_solution_tag_from_rg" {
  source              = "../terraform-azure-alz-core-platform-management-group-policy-assignment"
  management_group_id = module.root_management_group.id
  name                = "InheritSolutionTagRg"
  display_name        = "Inherit Solution tag from the resource group if missing"
  description         = "Adds the specified tag with its value from the parent resource group when any resource missing this tag is created or updated. Existing resources can be remediated by triggering a remediation task. If the tag exists with a different value it will not be changed."
  policy_id           = "/providers/Microsoft.Authorization/policyDefinitions/ea3f2387-9b95-492a-a190-fcdc54f7b070"
  parameters          = <<PARAMETERS
  {
    "tagName":{
        "value": "Solution"
    }
  }
  PARAMETERS
  managed_identity    = true

  providers = {
    azurerm = azurerm
  }
}


module "root_management_group_builtin_policy_enforce_project_tag_on_rg" {
  source              = "../terraform-azure-alz-core-platform-management-group-policy-assignment"
  management_group_id = module.root_management_group.id
  name                = "ForceProjectTagRg"
  display_name        = "Require a Project tag on resource groups"
  description         = "Enforces existence of a tag on resource groups."
  policy_id           = "/providers/Microsoft.Authorization/policyDefinitions/96670d01-0a4d-4649-9c89-2d3abc0a5025"
  parameters          = <<PARAMETERS
  {
    "tagName":{
        "value": "Project"
    }
  }
  PARAMETERS
  managed_identity    = false

  providers = {
    azurerm = azurerm
  }
}

module "root_management_group_builtin_policy_enforce_solution_tag_on_rg" {
  source              = "../terraform-azure-alz-core-platform-management-group-policy-assignment"
  management_group_id = module.root_management_group.id
  name                = "ForceSolutionTagRg"
  display_name        = "Require a Solution tag on resource groups"
  description         = "Enforces existence of a tag on resource groups."
  policy_id           = "/providers/Microsoft.Authorization/policyDefinitions/96670d01-0a4d-4649-9c89-2d3abc0a5025"
  parameters          = <<PARAMETERS
  {
    "tagName":{
        "value": "Solution"
    }
  }
  PARAMETERS
  managed_identity    = false

  providers = {
    azurerm = azurerm
  }
}

module "root_management_group_builtin_policy_enforce_project_tag_on_resources" {
  source              = "../terraform-azure-alz-core-platform-management-group-policy-assignment"
  management_group_id = module.root_management_group.id
  name                = "ForceProjectTagResource"
  display_name        = "Require a Project tag on resources"
  description         = "Enforces existence of a tag. Does not apply to resource groups."
  policy_id           = "/providers/Microsoft.Authorization/policyDefinitions/871b6d14-10aa-478d-b590-94f262ecfa99"
  parameters          = <<PARAMETERS
  {
    "tagName":{
        "value": "Project"
    }
  }
  PARAMETERS
  managed_identity    = false

  providers = {
    azurerm = azurerm
  }
}


module "root_management_group_builtin_policy_enable_azure_monitor_for_vms" {
  source              = "../terraform-azure-alz-core-platform-management-group-policy-assignment"
  management_group_id = module.root_management_group.id
  name                = "EnableAzureMonForVmS"
  display_name        = "Enable Azure Monitor for VMs"
  description         = "Enable Azure Monitor for the virtual machines (VMs) in the specified scope (management group, subscription or resource group). Takes Log Analytics workspace as parameter."
  policy_id           = "/providers/Microsoft.Authorization/policySetDefinitions/55f3eceb-5573-4f18-9695-226972c6d74a"
  parameters          = <<PARAMETERS
  {
      "logAnalytics_1": {
        "value": "${module.log_analytics_workspace.id}"
      }
  }
  PARAMETERS
  managed_identity    = true

  providers = {
    azurerm = azurerm
  }
}