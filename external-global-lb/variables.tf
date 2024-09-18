variable "project_id" {
  description = "Project id of the filestore instance."
  type        = string
}

variable "resource_name" {
  description = "Resource name to be used for all Global External LB components."
  type        = string
}

variable "network" {
  description = "Network in which the External LB will be launched."
  type        = string
}

variable "neg_subnet" {
  description = "Network in which the NEG will be launched."
  type        = string
}

variable "neg_default_port" {
  description = "NEG default port."
  type        = string
}

variable "neg_zone" {
  description = "Zone in which the NEG is residing."
  type        = string
}

variable "session_affinity" {
  description = "Session affinity for the External LB Backend."
  type        = string
  default     = "NONE"
}

variable "security_policy" {
  description = "Name of the security policy to be applied to the External LB's backend."
  type        = string
}

variable "ssl_policy_name" {
  description = "Name of the SSL policy to be applied to the External LB's target https proxy."
  type        = string
}

variable "http_health_check_path" {
  description = "Backend HTTP health check path."
  type        = string
}

variable "enable_cdn" {
  description = "Select whether to enable CDN."
  type        = bool
  default     = false
}

variable "managed_domains" {
  description = "List of managed domains for the managed SSL Certificate."
  type        = list(string)
}


variable "host_rule_config" {
  description = "URL Map host rules configuration."
  type        = map(map(string))
}

variable "use_iap" {
  description = "Select whether to enable IAP for the LB."
  type        = bool
  default     = false
}

variable "oauth2_client_id" {
  description = "IAP oauth client ID."
  type        = string
  sensitive   = true
  default     = ""
}

variable "oauth2_client_secret" {
  description = "Name of the security policy to be applied to the External LB's backend."
  type        = string
  sensitive   = true
  default     = ""
}

variable "generate_managed_ssl_certificate" {
  description = "Select whether to generated a Google Managed SSL Certificate"
  type        = bool
  default     = false
}




