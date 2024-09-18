variable "project_id" {
  description = "Project id of the filestore instance."
  type        = string
}

variable "loadbalancer_name" {
  description = "Resource name to be used for all Global External LB components."
  type        = string
}

variable "ssl_policy_name" {
  description = "Name of the SSL policy to be applied to the External LB's target https proxy."
  type        = string
}

variable "url_map_id" {
  description = "URL Map ID."
  type        = string
}

variable "ssl_certificates" {
  description = "Names of the self managed SSL certificate to be mounted to the LB"
  type        = list(string)
}


