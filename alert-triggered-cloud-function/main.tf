################################################
##### Create Bucket for The Cloud Function #####
################################################

resource "random_string" "suffix" {
  length  = 4
  upper   = false
  lower   = false
  numeric = true
  special = false
}

resource "google_storage_bucket" "cloud_function_bucket" {

    name            = "${var.project_id}-cloudfunction-source-bucket-${random_string.suffix.result}"  # Every bucket name must be globally unique
    location        = var.bucket_location
    project         = var.project_id
    storage_class   = "STANDARD"

    labels          = var.cloudfunction_labels

    public_access_prevention = "enforced"
    uniform_bucket_level_access = true

    depends_on = [
        random_string.suffix
    ]
}

#####################################################################
##### Grant Read Permission to Service Account for Bucket Objects ###
#####################################################################


resource "google_storage_bucket_iam_binding" "binding" {
    
    bucket       = google_storage_bucket.cloud_function_bucket.name
    role         = "roles/storage.objectViewer"
    members      = [
        "serviceAccount:${var.service_account_email}"
    ] 

    depends_on = [
        google_storage_bucket.cloud_function_bucket
    ]

}

####################################################
##### Add the Source Code Zip file to the Bucket ###
####################################################

resource "google_storage_bucket_object" "source_file" {

    name   = var.source_file_name
    source = var.source_file_path
    bucket = google_storage_bucket.cloud_function_bucket.name

    metadata = {}

    event_based_hold = false

    temporary_hold = false

    depends_on = [
        google_storage_bucket.cloud_function_bucket
    ]

}


######################################################
##### Create The Cloud Function ( 2nd Generation) ####
######################################################


resource "google_cloudfunctions2_function" "pubsub_reader" {

    name        = var.function_name
    location    = var.function_location
    description = var.function_description

    labels      = var.cloudfunction_labels

    project     = var.project_id

    build_config {

        runtime     = var.function_runtime
        entry_point = var.function_entry_point

        docker_repository = "projects/${var.project_id}/locations/europe-west1/repositories/gcf-artifacts"

        source {
            storage_source {
                bucket  = google_storage_bucket.cloud_function_bucket.name
                object  = google_storage_bucket_object.source_file.name
            }
        }
    }

    service_config {
        max_instance_count      = 1
        available_memory        = var.function_memory
        timeout_seconds         = 60
        service_account_email   = var.service_account_email
        ingress_settings        = "ALLOW_INTERNAL_ONLY"
        all_traffic_on_latest_revision = true
        environment_variables  = var.environment_variables
    }

    event_trigger {

        trigger_region  = var.function_location
        event_type      = "google.cloud.pubsub.topic.v1.messagePublished"
        pubsub_topic    = var.pubsub_topic_name
        retry_policy    = var.retry_policy

    }

    depends_on = [
        google_storage_bucket.cloud_function_bucket,
        google_storage_bucket_object.source_file
    ]

    lifecycle {
        replace_triggered_by = [
            google_storage_bucket_object.source_file.detect_md5hash
        ]
    }
}
