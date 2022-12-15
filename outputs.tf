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