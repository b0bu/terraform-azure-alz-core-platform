// data structures used to build platform landingzone output for troubleshooting
output "managed_identity_policy_assignments" {
  value = local.managed_identity_policy_assignments
}

output "managed_identity_principal_ids" {
  value = local.managed_identity_principal_ids
}

output "managed_identity_policy_assignment_roles" {
  value = local.managed_identity_policy_assignment_roles
}

# output "subscription_billing_scope" {
#   value = data.azurerm_billing_enrollment_account_scope.ea.id
# }

output "account_id" {
  value = data.azurerm_client_config.core.client_id
}
