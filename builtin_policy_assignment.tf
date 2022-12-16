module "root_management_group_builtin_policy_assigment_allowed_locations" {
  source              = "../terraform-azure-alz-core-platform-management-group-policy-assignment"
  management_group_id = module.root_management_group.id
  name                = "Allowed-locations"
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

