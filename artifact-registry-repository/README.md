This module creates an artifact registry repository and configures IAM for access.

 # Example Use of the Module 

```hcl

 module "docker_artifact_registry" {
    source          = "../../../infra/terraform-modules/artifact-registry-repository/"

    location        = "europe"
    repo_id         = "docker-repo"
    description     = "Docker repository for gke cluster."
    repo_type       = "DOCKER"
    labels          = {

        type        = "docker"
        environment = "my-environment"
        cluster     = "my-cluster"

    }
    project_id      = "my-project"


    iam_bindings = {
        "roles/artifactregistry.reader" = [
            "serviceAccount:<gke-nodes-service-account-email>",
        ]

        "roles/artifactregistry.writer" = [
            "serviceAccount:<image-builder-service-account-email>"
        ]

        "roles/artifactregistry.repoAdmin" = [
            "user:<admin-user-email>"
        ]
    }
}
    
```