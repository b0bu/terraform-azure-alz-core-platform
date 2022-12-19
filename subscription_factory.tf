data "azurerm_billing_enrollment_account_scope" "ea" {
  billing_account_name    = var.billing_account_name
  enrollment_account_name = var.enrollment_account_name
}


module "alz-connectivity-001" {
  source   = "Azure/lz-vending/azurerm"
  version  = "2.1.0"
  location = "uksouth"

  subscription_alias_enabled = true
  subscription_billing_scope = data.azurerm_billing_enrollment_account_scope.ea.id
  subscription_display_name  = "alz-connectivity-001"
  subscription_alias_name    = "connectivity-001"
  subscription_workload      = "Production"

  subscription_management_group_association_enabled = true
  subscription_management_group_id                  = module.platform_management_groups["Connectivity"].id

  virtual_network_enabled = false
  role_assignment_enabled = false
  disable_telemetry       = true

  subscription_tags = {
    terraform_managed = "true"
    source            = "Azure/lz-vending/azurerm"
    source_version    = "2.1.0"
  }

  providers = {
    azurerm = azurerm.subscription_factory
    azapi   = azapi
  }
}

module "alz-connectivity-002" {
  source   = "Azure/lz-vending/azurerm"
  version  = "2.1.0"
  location = "uksouth"

  subscription_alias_enabled = true
  subscription_billing_scope = data.azurerm_billing_enrollment_account_scope.ea.id
  subscription_display_name  = "alz-connectivity-002"
  subscription_alias_name    = "connectivity-002"
  subscription_workload      = "Production"

  subscription_management_group_association_enabled = true
  subscription_management_group_id                  = module.platform_management_groups["Connectivity"].id

  virtual_network_enabled = false
  role_assignment_enabled = false
  disable_telemetry       = true

  subscription_tags = {
    terraform_managed = "true"
    source            = "Azure/lz-vending/azurerm"
    source_version    = "2.1.0"
  }

  providers = {
    azurerm = azurerm.subscription_factory
    azapi   = azapi
  }
}


module "alz-identity-001" {
  source   = "Azure/lz-vending/azurerm"
  version  = "2.1.0"
  location = "uksouth"

  subscription_alias_enabled = true
  subscription_billing_scope = data.azurerm_billing_enrollment_account_scope.ea.id
  subscription_display_name  = "alz-identity-001"
  subscription_alias_name    = "identity-001"
  subscription_workload      = "Production"

  subscription_management_group_association_enabled = true
  subscription_management_group_id                  = module.platform_management_groups["Identity"].id

  virtual_network_enabled = false
  role_assignment_enabled = false
  disable_telemetry       = true

  subscription_tags = {
    terraform_managed = "true"
    source            = "Azure/lz-vending/azurerm"
    source_version    = "2.1.0"
  }

  providers = {
    azurerm = azurerm.subscription_factory
    azapi   = azapi
  }
}

module "alz-management-001" {
  source   = "Azure/lz-vending/azurerm"
  version  = "2.1.0"
  location = "uksouth"

  subscription_alias_enabled = true
  subscription_billing_scope = data.azurerm_billing_enrollment_account_scope.ea.id
  subscription_display_name  = "alz-management-001"
  subscription_alias_name    = "management-001"
  subscription_workload      = "Production"

  subscription_management_group_association_enabled = true
  subscription_management_group_id                  = module.platform_management_groups["Management"].id

  virtual_network_enabled = false
  role_assignment_enabled = false
  disable_telemetry       = true

  subscription_tags = {
    terraform_managed = "true"
    source            = "Azure/lz-vending/azurerm"
    source_version    = "2.1.0"
  }

  providers = {
    azurerm = azurerm.subscription_factory
    azapi   = azapi
  }
}


module "alz-sandbox-001" {
  source   = "Azure/lz-vending/azurerm"
  version  = "2.1.0"
  location = "uksouth"

  subscription_alias_enabled = true
  subscription_billing_scope = data.azurerm_billing_enrollment_account_scope.ea.id
  subscription_display_name  = "alz-sandbox-001"
  subscription_alias_name    = "sandbox-001"
  subscription_workload      = "Production"

  subscription_management_group_association_enabled = true
  subscription_management_group_id                  = module.organisational_management_groups["Sandboxes"].id

  virtual_network_enabled = false
  role_assignment_enabled = false
  disable_telemetry       = true

  subscription_tags = {
    terraform_managed = "true"
    source            = "Azure/lz-vending/azurerm"
    source_version    = "2.1.0"
  }

  providers = {
    azurerm = azurerm.subscription_factory
    azapi   = azapi
  }
}

module "alz-corp-001" {
  source   = "Azure/lz-vending/azurerm"
  version  = "2.1.0"
  location = "uksouth"

  subscription_alias_enabled = true
  subscription_billing_scope = data.azurerm_billing_enrollment_account_scope.ea.id
  subscription_display_name  = "alz-corp-001"
  subscription_alias_name    = "corp-001"
  subscription_workload      = "DevTest"

  subscription_management_group_association_enabled = true
  subscription_management_group_id                  = module.application_management_groups["Corp"].id

  virtual_network_enabled = false
  role_assignment_enabled = false
  disable_telemetry       = true

  subscription_tags = {
    terraform_managed = "true"
    source            = "Azure/lz-vending/azurerm"
    source_version    = "2.1.0"
  }

  providers = {
    azurerm = azurerm.subscription_factory
    azapi   = azapi
  }
}