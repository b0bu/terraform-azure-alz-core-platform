provider "azurerm" {
  features {}
}

data "azurerm_subscriptions" "available" {}

locals {
  sandbox_management_group_subscription = [
    for sub in data.azurerm_subscriptions.available.subscriptions : sub.subscription_id
    if sub.display_name == "alz-sandbox-subscription-001"
  ]

  management_management_group_subscription = [
    for sub in data.azurerm_subscriptions.available.subscriptions : sub.subscription_id
    if sub.display_name == "alz-sandbox-subscription-001"
  ]
}

provider "azurerm" {
  alias           = "sandbox"
  subscription_id = local.sandbox_management_group_subscription[0]
  features {}
}

provider "azurerm" {
  alias           = "management"
  subscription_id = local.management_management_group_subscription[0]
  features {}
}