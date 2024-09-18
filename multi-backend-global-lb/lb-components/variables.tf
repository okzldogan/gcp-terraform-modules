variable "project_id" {
  description = "Project id of the filestore instance."
  type        = string
}

variable "resource_name" {
  description = "Resource name to be used for all Global External LB components."
  type        = string
}

variable "ssl_policy_name" {
  description = "Name of the SSL policy to be applied to the External LB's target https proxy."
  type        = string
}

variable "self_managed_ssl_certificates" {
  description = "Names of the self managed SSL certificate to be mounted to the LB"
  type        = list(string)
}


variable "managed_ssl_certificate_config" {

  type = list(object({
    domains = list(string)
  }))

  description = "Managed SSL Certficate Configuration."

  default = []

}

variable "url_map_id" {
  description = "URL map ID."
  type        = string
}

