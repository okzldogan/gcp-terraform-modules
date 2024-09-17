####################################
### Create Logging Bucket    #######
####################################

resource "google_logging_project_bucket_config" "logging_bucket" {

    project         = var.logging_bucket_project_id
    location        = var.logging_bucket_location
    retention_days  = var.log_retention_days
    bucket_id       = var.logging_bucket_id
    description     = var.logging_bucket_description

    dynamic "cmek_settings" {
        for_each = var.encrypt_logs ? [1] : []

        content {
            kms_key_name = var.logging_bucket_encryption_key
        }
    }


}


###########################################################
### Create Log Sink for the Application Namespace   #######
###########################################################

resource "google_logging_project_sink" "log_sink" {
    
    name        = var.log_sink_name
    destination = "logging.googleapis.com/${google_logging_project_bucket_config.logging_bucket.id}"

    filter      = "resource.type=\"k8s_cluster\" jsonPayload.type=\"FINDING_TYPE_VULNERABILITY\" jsonPayload.resourceName=\"apps/v1/namespaces/${var.k8s_namespace}/Deployment/${var.k8s_deployment_name}\""
    description = var.logging_bucket_description

    project     = var.sink_host_project

    unique_writer_identity = true

    depends_on = [google_logging_project_bucket_config.logging_bucket]

}

###########################################################
### Create Log Sink for the Application Namespace   #######
###########################################################

resource "google_project_iam_member" "logbucket_sink_member" {

    project = var.logging_bucket_project_id
    role    = "roles/logging.bucketWriter"
    member  = google_logging_project_sink.log_sink.writer_identity

    condition {
        title       = "Logging Bucket writer permission."
        description = "Grants logging.bucketWriter role to the log writer service account."
        expression  = "resource.name.endsWith(\"locations/${google_logging_project_bucket_config.logging_bucket.location}/buckets/${google_logging_project_bucket_config.logging_bucket.bucket_id}\")"
    }

    depends_on = [google_logging_project_sink.log_sink]

}
