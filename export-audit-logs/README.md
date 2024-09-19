This module creates a logging bucket to store the audit logs that are being exported from a GCP project to a GCP monitoring project or else.

The logs are exported via log sink and later log sink SA is granted the bucketWriter permission to write the exported logs to the logging bucket.


# Example Use of the Module 

```hcl

module "my_project_audit_logs_export" {
  source          = "../../terraform-modules/export-audit-logs/"

  logging_bucket_project_id     = "my-monitoring-project"
  logging_bucket_location       = "my-region"
  log_retention_days            = 120
  logging_bucket_id             = "audit-logs-export-my-project"
  encrypt_logs                  = false     # set to true if you want to encrypt the logs

  log_sink_name                 = "my-project-audit-logs"

  sink_host_project             = "my-application-project"


}

```
