variable "project_id" {
  description = "Project id"
  type        = string
}

variable "notification_channels_config" {
  type        = list(map(string))
  description = "The configuration info for the alert."
}

