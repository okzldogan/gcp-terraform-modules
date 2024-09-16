variable "project_id" {
  description = "The project in which the alert policy& uptime check will be created."
  type        = string
}

variable "uptime_check_request_wait_time" {
  description = "Maximum time to wait for the request to complete (in seconds)"
  type        = string
  default     = "30s"
}

variable "uptime_url" {
  description = "URL to be checked for the uptime."
  type        = string
}

variable "selected_regions" {
  description = "List of regions for the uptime check"
  type        = list(string)
  default = [
    "EUROPE",
    "USA",
    "SOUTH_AMERICA",
    "ASIA_PACIFIC"
  ]
}

variable "uptime_check_frequency" {
  description = "How often the uptime check is performed (in seconds)."
  type        = string
  default     = "300s"
}

variable "http_check_path" {
  description = "Up time check path."
  type        = string
  default     = "/"
}

variable "uptime_check_display_name" {
  description = "Name of the app for adding it as a label to the uptime check resource."
  type        = string
}

variable "content_matchers" {
    type = map(object({
        content = string
        matcher = string
    }))
    default = {}
}

variable "accepted_response_status_codes" {
    type = any
}

variable "mask_headers" {
    type = bool
    default = false
}


variable "alert_notification_channels" {
  description = "Notification channels"
  type        = list(string)
}

variable "alert_auto_close" {
  description = "If an alert policy that was active has no data for this long, any open incidents will close"
  type        = string
  default     = "86400s" # Corresponds to 1 day
}

variable "trigger_count" {
  description = "Count required to trigger the alert."
  type        = number
  default     = 1
}








