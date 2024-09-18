This module create a Cloud Bucket with the option to configure CORS and Lifecyle Rules.

The bucket ID should be globally unique, therefore a random suffix of 4 digit number is generated and assigned to the bucket ID. 
Moreover the bucket ID gets the project name as the prefix.


Example Use of the Module 

```hcl

module "gcp_bucket_with_cors" {
    source          = "../../../terraform-modules/gcp-bucket-with-iam-binding/"

    project_id          = "my-project"

    # Generates the <project-id>-dev-cors-<random-suffix> Bucket ID
    # For instance: my-project-cors-1234
    bucket_id           = "cors"
    bucket_location     = "MY-REGION"
    storage_class       = "STANDARD"
    force_destroy       = false

    versioning          = false # set to true to enable versioning

    cors_config = {

        "MY-ENVIRONMENT" = {
            origin          = [
                "https://my-app.my-domain.com/",
            ]
            method          = [
                "PUT",
                "POST",
            ]
            response_header = ["Content-Type"]
            max_age_seconds = 3600
        }
    }

    lifecycle_rules = [
        # Deletes an object after 365 days
        {
            action = {
                type    = "Delete"
            }
            condition = {
                age     = 365
                with_state = "ANY"
            }
        },
        # Changes the Storage Class of an object
        # from 'STANDARD' to 'NEARLINE' after 30 days
        {
            action = {
                type            = "SetStorageClass"
                storage_class   = "NEARLINE"
            }
            condition = {
                age     = 30
                matches_storage_class = "STANDARD"
            }
        },
        # Changes the Storage Class of an object
        # if it is 'NEARLINE' or 'STANDARD 
        # to 'COLDLINE' after 90 days
        {
            action = {
                type            = "SetStorageClass"
                storage_class   = "COLDLINE"
            }
            condition = {
                age     = 90
                matches_storage_class = "NEARLINE,STANDARD"
            }
        },
    ]

    bucket_folders      = [
        "my-folder",
    ]

    bucket_labels = {
        environment = "my_environment"
        usage       = "cors"
        application = "my_app"
    }

    bindings = {
        
        # Read-Only Access to Bucket's Objects
        # "roles/storage.objectViewer" = [
        #     "user:my-email"
        # ]

        # Read & Write Access
        "roles/storage.objectAdmin"  = [
            "serviceAccount:my-service-account-email",
        ]

    }


}

```