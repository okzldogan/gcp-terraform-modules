variable "cloudsql_project_reference" {
  description = "The project in which the alert policy will be created."
  type        = string
}

variable "project_id" {
  description = "The project in which the alert policy will be created."
  type        = string
}

variable "notification_channels" {
  description = "Alert Notification Channels."
  type        = list(string)
}

variable "alert_auto_close" {
  description = "If an alert policy that was active has no data for this long, any open incidents will close"
  type        = string
  default     = "7200s" # Corresponds to 2 hours
}

variable "cloudsql_db_id" {
  description = "CloudSQL Connection string DB ID."
  type        = string
}

variable "active_connections_threshold" {
  description = "CloudSQL Connection Active Connections Threshold to trigger alert."
  type        = string
}

variable "max_active_connections" {
  description = "Max. Active Connections allowed to CloudSQL Instance."
  type        = string
}






