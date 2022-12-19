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

module "root_management_group_role_assignment_for_policy_inherit_project_tag_from_rg" {
  source       = "../terraform-azure-alz-role-assignment"
  principal_id = module.root_management_group_builtin_policy_inherit_project_tag_from_rg.assignment.identity[0].principal_id
  role_name    = "Contributor"
  scope        = module.root_management_group.id

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

module "root_management_group_role_assignment_for_policy_inherit_solution_tag_from_rg" {
  source       = "../terraform-azure-alz-role-assignment"
  principal_id = module.root_management_group_builtin_policy_inherit_solution_tag_from_rg.assignment.identity[0].principal_id
  role_name    = "Contributor"
  scope        = module.root_management_group.id

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
  name                = "EnableAzureMonForVms"
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

module "root_management_group_role_assignment_for_policy_enable_azure_monitor_for_vms" {
  source       = "../terraform-azure-alz-role-assignment"
  principal_id = module.root_management_group_builtin_policy_enable_azure_monitor_for_vms.assignment.identity[0].principal_id
  role_name    = "Log Analytics Contributor"
  scope        = module.root_management_group.id

  providers = {
    azurerm = azurerm
  }
}


module "root_management_group_builtin_policy_enable_azure_monitor_for_vmss" {
  source              = "../terraform-azure-alz-core-platform-management-group-policy-assignment"
  management_group_id = module.root_management_group.id
  name                = "EnableAzureMonForVmss"
  display_name        = "Enable Azure Monitor for Virtual Machine Scale Sets"
  description         = "Enable Azure Monitor for the Virtual Machine Scale Sets in the specified scope (Management group, Subscription or resource group). Takes Log Analytics workspace as parameter. Note: if your scale set upgradePolicy is set to Manual, you need to apply the extension to the all VMs in the set by calling upgrade on them. In CLI this would be az vmss update-instances."
  policy_id           = "/providers/Microsoft.Authorization/policySetDefinitions/75714362-cae7-409e-9b99-a8e5075b7fad"
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

module "root_management_group_role_assignment_for_policy_enable_azure_monitor_for_vmss" {
  for_each     = toset(["Log Analytics Contributor", "Virtual Machine Contributor"])
  source       = "../terraform-azure-alz-role-assignment"
  principal_id = module.root_management_group_builtin_policy_enable_azure_monitor_for_vmss.assignment.identity[0].principal_id
  role_name    = each.value
  scope        = module.root_management_group.id

  providers = {
    azurerm = azurerm
  }
}

module "root_management_group_builtin_policy_enable_monitoring_in_azure_security_center" {
  source              = "../terraform-azure-alz-core-platform-management-group-policy-assignment"
  management_group_id = module.root_management_group.id
  name                = "AzureSecurityBenchmark"
  display_name        = "Enable Monitoring in Azure Security Center"
  description         = "The Azure Security Benchmark initiative represents the policies and controls implementing security recommendations defined in Azure Security Benchmark v3, see https://aka.ms/azsecbm. This also serves as the Microsoft Defender for Cloud default policy initiative. You can directly assign this initiative, or manage its policies and compliance results within Microsoft Defender for Cloud."
  policy_id           = "/providers/Microsoft.Authorization/policySetDefinitions/1f3afdf9-d0c9-4c3d-847f-89da613e70a8"

  managed_identity    = false

  providers = {
    azurerm = azurerm
  }
}

module "root_management_group_builtin_policy_configure_loganalytics_for_windows_arc_servers" {
  source              = "../terraform-azure-alz-core-platform-management-group-policy-assignment"
  management_group_id = module.root_management_group.id
  name                = "DeployWSArcMonitoring"
  display_name        = "Configure Log Analytics extension on Azure Arc enabled Windows servers"
  description         = "Enable VM insights on servers and machines connected to Azure through Arc enabled servers by installing the Log Analytics virtual machine extension. VM insights uses the Log Analytics agent to collect the guest OS performance data, and provides insights into their performance. See more - https://aka.ms/vminsightsdocs. Deprecation notice: The Log Analytics agent is on a deprecation path and won't be supported after August 31, 2024. You must migrate to the replacement 'Azure Monitor agent' prior to that date."
  policy_id           = "/providers/Microsoft.Authorization/policyDefinitions/69af7d4a-7b18-4044-93a9-2651498ef203"
  parameters          = <<PARAMETERS
  {
      "logAnalytics": {
        "value": "${module.log_analytics_workspace.id}"
      }
  }
  PARAMETERS
  managed_identity    = true

  providers = {
    azurerm = azurerm
  }
}

module "root_management_group_role_assignment_for_policy_configure_loganalytics_for_windows_arc_servers" {
  source       = "../terraform-azure-alz-role-assignment"
  principal_id = module.root_management_group_builtin_policy_configure_loganalytics_for_windows_arc_servers.assignment.identity[0].principal_id
  role_name    = "Log Analytics Contributor"
  scope        = module.root_management_group.id

  providers = {
    azurerm = azurerm
  }
}

module "root_management_group_builtin_policy_configure_loganalytics_for_linux_arc_servers" {
  source              = "../terraform-azure-alz-core-platform-management-group-policy-assignment"
  management_group_id = module.root_management_group.id
  name                = "DeployLXArcMonitoring"
  display_name        = "Configure Log Analytics extension on Azure Arc enabled Linux servers. See deprecation notice below"
  description         = "Enable VM insights on servers and machines connected to Azure through Arc enabled servers by installing the Log Analytics virtual machine extension. VM insights uses the Log Analytics agent to collect the guest OS performance data, and provides insights into their performance. See more - https://aka.ms/vminsightsdocs. Deprecation notice: The Log Analytics agent is on a deprecation path and won't be supported after August 31, 2024. You must migrate to the replacement 'Azure Monitor agent' prior to that date"
  policy_id           = "/providers/Microsoft.Authorization/policyDefinitions/9d2b61b4-1d14-4a63-be30-d4498e7ad2cf"
  parameters          = <<PARAMETERS
  {
      "logAnalytics": {
        "value": "${module.log_analytics_workspace.id}"
      }
  }
  PARAMETERS
  managed_identity    = true

  providers = {
    azurerm = azurerm
  }
}

module "root_management_group_role_assignment_for_policy_configure_loganalytics_for_linux_arc_servers" {
  source       = "../terraform-azure-alz-role-assignment"
  principal_id = module.root_management_group_builtin_policy_configure_loganalytics_for_linux_arc_servers.assignment.identity[0].principal_id
  role_name    = "Log Analytics Contributor"
  scope        = module.root_management_group.id

  providers = {
    azurerm = azurerm
  }
}

module "root_management_group_builtin_policy_actvity_log_diagnostics_to_log_analytics_workspace" {
  source              = "../terraform-azure-alz-core-platform-management-group-policy-assignment"
  management_group_id = module.root_management_group.id
  name                = "AzActivityLogDiagToLaw"
  display_name        = "Configure Azure Activity logs to stream to specified Log Analytics workspace"
  description         = "Deploys the diagnostic settings for Azure Activity to stream subscriptions audit logs to a Log Analytics workspace to monitor subscription-level events"
  policy_id           = "/providers/Microsoft.Authorization/policyDefinitions/2465583e-4e78-4c15-b6be-a36cbc7c8b0f"
  parameters          = <<PARAMETERS
  {
      "logAnalytics": {
        "value": "${module.log_analytics_workspace.id}"
      }
  }
  PARAMETERS
  managed_identity    = true

  providers = {
    azurerm = azurerm
  }
}

module "root_management_group_role_assignment_for_policy_actvity_log_diagnostics_to_log_analytics_workspace" {
  for_each     = toset(["Log Analytics Contributor", "Monitoring Contributor"])
  source       = "../terraform-azure-alz-role-assignment"
  principal_id = module.root_management_group_builtin_policy_actvity_log_diagnostics_to_log_analytics_workspace.assignment.identity[0].principal_id
  role_name    = each.value
  scope        = module.root_management_group.id

  providers = {
    azurerm = azurerm
  }
}