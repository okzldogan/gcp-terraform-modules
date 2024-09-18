This module creates a Workload Identity Pool for authentication from Github to GCP.

## Example Use of the Module

```hcl

# Create Workload ID Pool for Github


module "github_workload_id_pool" {
    source          = "../../../infra/terraform-modules/iam-workload-identity-pool-oidc/"

    project_id                  = "my-workload-id-pool-project"
    pool_id                     = "github-pool"                        
    pool_display_name           = "GitHub Pool for Actions"
    pool_description            = "Identity Pool for Deployments with GitHub Actions."
    disabled                    = false

    provider_id                 = "github-provider-oidc"
    provider_display_name       = "GitHub Provider with OIDC"
    provider_description        = "Provider for GitHub Actions using OIDC"


    allowed_audiences           = ["https://iam.googleapis.com/projects/insert-project-number/locations/global/workloadIdentityPools/github-pool/providers/github-provider-oidc"] 

    issuer_uri                  = "https://token.actions.githubusercontent.com"

    sa_mapping  = {
        "sa-github-action-terraform" = {
            sa_name     =  "projects/my-project/serviceAccounts/sa-name@my-project.iam.gserviceaccount.com"
            attribute   = "attribute.repository/my-org/my-repo"
        },
        "sa-gke-github-dev" = {
            sa_name     =  "projects/other-project/serviceAccounts/other-sa-name@other-project.iam.gserviceaccount.com"
            attribute   = "attribute.repository/my-org/other-repo"
        },

    }

```
