variable "project_id" {
  description = "Project id of the filestore instance."
  type        = string
}

variable "http_health_check_prefix" {
  description = "HTTP health check resource prefix."
  type        = string
}


variable "backend_services" {
  type = list(object({
    name            = string
    enable_cdn      = bool
    security_policy = string

  }))

  default = []
}



