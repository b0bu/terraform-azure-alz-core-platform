# terraform-azure-alz-core-platform
NIST SP 800-53 and CIS 1.4 compliant management group hierarchy

run
```
terraform init -backend-config=backend.conf
```


### adding a policy
- add the file to policy-factory in the correct directory initiative / definition for the correct archetype
- If the policy has values to template add them to this main tf
- If the policy requires a managed identity then add it to this main tf
