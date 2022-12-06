# terraform-azure-alz-core-platform
NIST SP 800-53 and CIS 1.4 compliant management group hierarchy

data model is meant to absract the complexity and allow variable versioning

where no updates were applied to the policies governing root node
```
module "myorg_root_management_group_policy_factory" {
  source = "../terraform-azure-alz-core-platform-management-group-policy-factory"
  version = "0.0.1"
  archetype = "root"
}
```
where updates to organisational mg policy can be applied in a versioned way
```
module "organisational_management_groups_policy_factory" {
  source = "../terraform-azure-alz-core-platform-management-group-policy-factory"
  version = "0.0.2"
  archetype = "organisation"
}
```
this way factory definition only needs to change it's version when it's particular policies were updated and there's no reason to update any other block definition. 
```
module "myorg_root_management_group_policy_factory" {
  source = "../terraform-azure-alz-core-platform-management-group-policy-factory"
  version = "0.0.3"
  archetype = "root"
}
```

