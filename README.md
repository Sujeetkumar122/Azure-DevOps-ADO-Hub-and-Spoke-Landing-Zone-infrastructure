# Azure-DevOps-ADO-Hub-and-Spoke-Landing-Zone-infrastructure

## Azure DevOps pipeline

The `azure-pipelines.yml` pipeline validates Terraform and creates a plan when
`main` is updated. Applying is opt-in: queue the pipeline with **Apply the
reviewed Terraform plan** enabled. The apply stage consumes the exact plan
created by the plan stage.

### One-time Azure DevOps setup

1. Install the **Terraform** Azure Pipelines extension that provides
   `TerraformInstaller@1`.
2. Create an Azure Resource Manager service connection and update
   `azureServiceConnection` in `azure-pipelines.yml`.
3. Provision an Azure Storage account and a private blob container for Terraform
   state before running the pipeline. Update `tfStateResourceGroup`,
   `tfStateStorageAccount`, and (if needed) `tfStateContainer` in the YAML.
   The service connection identity needs `Contributor` on the deployment
   subscription and `Storage Blob Data Contributor` on the state container.
4. Create the variable group named `terraform-secrets`, authorize this pipeline
   to use it, and add `TF_VAR_vm_admin_password` as a secret variable.
5. Create Azure DevOps environments named `terraform-preprod` and
   `terraform-prod`. Configure approvals/checks on these environments to gate
   the apply stage; production approvals should be managed on
   `terraform-prod`.
6. Set the pipeline's YAML path to this file and ensure the branch name in the
   `trigger` matches your default branch if it is not `main`.

The backend uses Azure AD authentication via the Azure service connection.
Keep the state storage private and tightly permissioned: Terraform state and
saved plan files can contain sensitive values. Azure DevOps artifacts and logs
should be accessible only to trusted pipeline users. Do not commit passwords,
state files, or saved plans.

If either environment already has infrastructure tracked in a local Terraform
state, migrate that state to its matching Azure Blob backend before running the
pipeline. Authenticate locally with an identity that can access the state
container, then run the following from the matching environment directory,
replacing the placeholders with the same values used by the pipeline:

```sh
terraform init -migrate-state \
  -backend-config="resource_group_name=<state-resource-group>" \
  -backend-config="storage_account_name=<state-storage-account>" \
  -backend-config="container_name=tfstate" \
  -backend-config="key=preprod.terraform.tfstate" \
  -backend-config="use_azuread_auth=true" \
  -backend-config="use_cli=true"
```

Use `key=prod.terraform.tfstate` from the `prod` directory. Do not let the
pipeline initialize an empty state for infrastructure that is already
deployed.

Local state backups in the workspace may contain the old VM password. Treat
that credential as exposed: rotate it, and keep those state files out of source
control and other broadly accessible locations.