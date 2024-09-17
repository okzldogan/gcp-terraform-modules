This module creates a logging bucket to store the Container Image Findings that are generated within the GKE project to the logging bucket project id ( destionation project for the log sink).

The logs are exported via log sink and later log sink SA is granted the bucketWriter permission to write the exported logs to the logging bucket.

This log sink is to be used for setting alerts for container image vulnerabilities via a custom log metric.


######################################
##### Example Use of the Module ######
######################################

module "log_sink_container_analysis_findings" {
  source          = "../terraform-modules/log-sink-container-image-findings/"

  logging_bucket_project_id     = "my-project"
  logging_bucket_location       = "europe-west1"
  log_retention_days            = 120
  logging_bucket_id             = "my-deployment-image-anaylsis-findings"
  logging_bucket_description    = "Container security findings for the  <my-deployment> in the <my-namespace> namespace in the <my-gke-cluster> cluster."
  encrypt_logs                  = false # Set to true to encrypt logs

  log_sink_name                 = "<my-deployment>-container-image-vulnerabilities"

  k8s_namespace                 = "<my-namespace>"

  k8s_deployment_name           = <my-deployment>"

  sink_host_project             = "<my-gke-cluster>"


}