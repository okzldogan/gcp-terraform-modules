variable "project_id" {
  description = "Project id"
  type        = string
}

variable "backend_config" {
  type        = list(object(
    {
      name = string,
      healthy_threshold = number,
      healthcheck_timeout_sec = number
      check_interval_sec = number,
      health_check_port = number,
      port_specification = string,
      health_check_path = string,
      enable_cdn = bool,
      backend_timeout = number,
      custom_request_headers = list(string),
      custom_response_headers = list(string),
      neg_name = string,
      neg_zone_1 = string,
      neg_zone_2 = string,
      security_policy = string

    }
  ))
  description = "The configuration info for the backends."
}

