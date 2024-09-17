resource "google_bigquery_dataset" "dataset" {                                

    dataset_id                  = var.bq_dataset_id 
    friendly_name               = var.dataset_descriptive_name
    description                 = var.bq_dataset_description 
    location                    = var.bq_dataset_location 
    project                     = var.project_id

    delete_contents_on_destroy  = var.delete_contents_on_destroy 

    max_time_travel_hours       = var.data_recovery_time

    storage_billing_model       = var.storage_billing_model

    default_table_expiration_ms = var.dataset_expiration_time # Default Set for 3 months in Variables

    dynamic "default_encryption_configuration" {
        for_each  = var.use_encryption_key ? [1] : []

        content {
        kms_key_name = var.kms_key_name
        }
    }


    labels = var.dataset_labels


}

#########################################################
##### Grant Dataset Access IAM Binding Permissions ######
#########################################################


resource "google_bigquery_dataset_iam_binding" "bigquery_dataset_iam_roles" {
    
    for_each    = var.bigquery_dataset_bindings

    dataset_id  = google_bigquery_dataset.dataset.dataset_id
    role        = each.key

    project     = var.project_id

    members     = each.value

    depends_on = [
        google_bigquery_dataset.dataset
    ]
}

