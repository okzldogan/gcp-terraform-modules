variable "project_id" {
  description = "Project id"
  type        = string
}

variable "notification_channels" {
  description = "Notification Channels"
  type        = list(string)
}

variable "pod_restart_monitoring_config" {
  type        = list(map(string))
  description = "The configuration info for the alert."
}

