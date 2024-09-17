variable "ssl_policy_name" {
  description = "Name of the SSL policy."
  type  = string
}

variable "ssl_policy_description" {
  description = "SSL policy description."
  type        = string
}

variable "ssl_policy_type" {
  description = "Specifies SSL features for the load balancer when negotiating SSL with clients.Possible values are COMPATIBLE, MODERN, RESTRICTED, and CUSTOM."
  type        = string
}

variable "min_tls_version" {
  description = "The minimum SSL version to establish a connection with the load balancer. Possible values are TLS_1_0, TLS_1_1, and TLS_1_2 ."
  type        = string
}

variable "custom_features" {
  description = "Only when SSL type is CUSTOM, insert features."
  type        = list(string)
  default     = []
}

variable "project_id" {
  description = "The project of the DNS Zone in which the DNS entry will be made."
  type        = string
}

