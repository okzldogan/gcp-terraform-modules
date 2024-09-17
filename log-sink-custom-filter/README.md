This module creates a logging bucket to store the logs with a custom filer which are to be exported from the GKE project to the app's monitoring project.

The logs are exported via log sink and later log sink SA is granted the bucketWriter permission to write the exported logs to the logging bucket.


######################################
##### Example Use of the Module ######
######################################


module "log_sink_companywebsite_staging_container_vulnerability_logs" {
  source          = "../terraform-modules/log-sink-custom-filter/"

  logging_bucket_project_id     = "my-project"
  logging_bucket_location       = "my-region"
  log_retention_days            = 120
  logging_bucket_id             = "myapp-myenvironment-container-vulnerability-logs"
  logging_bucket_description    = "Log sink for MY-APP MY-ENVIRONMENT container vulnerability logs"
  encrypt_logs                  = false

  log_sink_name                 = "myapp-myenvironment-container-vulnerability-log-sink"

  log_filter                    = "jsonPayload.type=\"FINDING_TYPE_VULNERABILITY\" jsonPayload.resourceName=~\"apps/v1/namespaces/my-namespace\""

  sink_host_project             = "gke-hosting-project"


}