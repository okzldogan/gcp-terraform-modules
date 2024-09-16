variable "project_id" {
  description = "Project ID in which the custom metric will be created."
  type        = string
}

variable "logging_bucket_name" {
  description = "Name of the logging bucket where the custom metric will be used."
  type        = string
}

variable "monitored_gcp_project" {
  description = "The GCP project name of the monitoring cloud sql instance."
  type        = string
}

variable "alert_notification_channels" {
  description = "List of alert notification channels"
  type        = list(string)
}

variable "link_to_logs" {
  description = "The link to be indicated in the documentation to get the logs in the console."
  type        = string
}

variable "environment" {
  description = "GCP Project Environment"
  type        = string
}

variable "db_engine" {
  description = "Database Engine; insert either mysql or postgresql"
  type        = string
}

variable "cloudsql_modifications_optional_condition" {
  description = "The link to be indicated in the documentation to get the logs in the console."
  type        = string
  default     = "NOT protoPayload.authenticationInfo.principalEmail=\"terraform-host@terraform-bastion.iam.gserviceaccount.com\""
}
