output "logging_bucket_id" {
    description = "ID of Logging Bucket"
    value       = google_logging_project_bucket_config.logging_bucket.id
}