variable "project_id" {
  description = "Project id"
  type        = string
}

variable "application_name" {
  description = "Application name reference of the Load Balancer"
  type        = string
}

variable "alert_notification_channels" {
  type        = list(string)
  description = "Alert notification channels"
}

variable "backend_latency_threshold" {
  description = "Backend Latency Alert Threshold"
  type        = string
}

variable "backend_name" {
  description = "Name of the monitored backend"
  type        = string
}

variable "link_to_dashboards" {
  description = "Link to dashboards for the Load Balancer performance."
  type        = string
}
