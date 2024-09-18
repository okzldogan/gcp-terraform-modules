
variable "zone_name" {
  description = "DNS Zone Name."
  type        = string
}

variable "project_id" {
  description = "The project of the DNS Zone in which the DNS entry will be made."
  type        = string
}

variable "domain_name" {
  description = "The domoain namein which the DNS entry will be made."
  type        = string
}

variable "recordsets" {
  type = list(object({
    name    = string
    type    = string
    ttl     = number
    records = list(string)
  }))
  description = "List of DNS record objects to manage, in the standard terraform dns structure. Type can be CNAME, A, TXT, MX, NS etc."
  default     = []
}