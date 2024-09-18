variable "project_id" {
  description = "Project id"
  type        = string
}

variable "notification_channels" {
  description = "List of notification channels for the alerts"
  type        = list(string)
}


variable "alerts_config" {
  type        = list(map(string))
  description = "The configuration info for the alert."
}

