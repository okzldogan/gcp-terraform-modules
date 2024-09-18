This module creates a big query dataset.
Grant the access permissions using the bigquery_dataset_bindings block to avoid conflicts.

Example Use of the Module:

```hcl

module "bigquery_my_dataset" {                                                     
    source          = "../terraform-modules/big-query-dataset/"

    bq_dataset_id               = "my_dataset"
    dataset_descriptive_name    = "My dataset Descriptive Name"
    bq_dataset_description      = "Dataset for analysis"
    bq_dataset_location         = "my-region"

    project_id                  = "my-project"
    delete_contents_on_destroy  = false
    dataset_expiration_time     = null            # null to keep the dataset indefinitely

    use_encryption_key          = true
    # Insert Key Name when "use_encryption_key " is true 
    kms_key_name                = "projects/my-key-project/locations/my-region/keyRings/my-key-ring/cryptoKeys/my-key-name""   

    dataset_labels              = {
        usage       = "insert_usage_here"
        type        = "insert_data_type_here"
    }

    bigquery_dataset_bindings = {
        "roles/bigquery.dataOwner"  = [
            "user:my-user@my-domain.com",
        ]
        "roles/bigquery.dataViewer" = [
            # Infra Team
            "group:my-group@my-domain.com",
        ]
    }

}

```