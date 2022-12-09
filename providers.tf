provider "azurerm" {
  features {}
}

data "azurerm_subscriptions" "available" {}

locals {
  subscription_for_testing = [
    for sub in data.azurerm_subscriptions.available.subscriptions : sub.subscription_id
    if sub.display_name == "alz-sandbox-subscription-001"
  ]
}

provider "azurerm" {
  alias           = "sandbox"
  subscription_id = local.subscription_for_testing[0]
  features {}
}