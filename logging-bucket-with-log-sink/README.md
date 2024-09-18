This module creates a logging bucket to store the logs that are being exported from the GKE project to the application's project.

The logs are exported via log sink and later log sink SA is granted the bucketWriter permission to write the exported logs to the logging bucket.

# Example Use of the Module 

```hcl

module "logging_bucket_aq_test" {
  source          = "../../../terraform-modules/logging-bucket-with-log-sink/"

  logging_bucket_project_id     = "my-project"
  logging_bucket_location       = "my-region"
  log_retention_days            = 90
  logging_bucket_id             = "my-namespace-gke-logs-export"
  logging_bucket_description    = "Logging export for my-namespace in the <insert-cluster-name> cluster."
  encrypt_logs                  = false

  log_sink_name                 = "my-namespace-namespace-logs"

  k8s_namespace                 = "my-namespace"

  sink_host_project             = "my-gke-hosting-project"


}

```
