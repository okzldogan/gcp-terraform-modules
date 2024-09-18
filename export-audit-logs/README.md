This module creates a logging bucket to store the audit logs that are being exported from a GCP project to a GCP monitoring project or else.

The logs are exported via log sink and later log sink SA is granted the bucketWriter permission to write the exported logs to the logging bucket.


######################################
##### Example Use of the Module ######
######################################

module "aq_dev_audit_logs_export" {
  source          = "../../terraform-modules/export-audit-logs/"

  logging_bucket_project_id     = "${var.prefix}-${var.name}"
  logging_bucket_location       = "europe-west1"
  log_retention_days            = 90
  logging_bucket_id             = "audit-logs-export-aq-dev"
  encrypt_logs                  = false

  log_sink_name                 = "aq-dev-audit-logs"

  sink_host_project             = "sp-antarctica-dev"


}