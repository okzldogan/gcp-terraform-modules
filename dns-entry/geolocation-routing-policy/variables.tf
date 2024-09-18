variable "dns_entry_name" {
  description = "Name of the DNS Entry"
  type  = string
}

variable "project_id" {
  description = "The project of the DNS Zone in which the DNS entry will be made."
  type        = string
}

variable "zone_name" {
  description = "DNS Zone Name."
  type        = string
}

variable "domain_name" {
  description = "DNS Domain Name."
  type        = string
}

variable "TTL" {
  description = "Time to Live for the DNS entry."
  type        = number
}

variable "dns_record_type" {
  description = "DNS Record type, accept values such as A, NS, TXT etc."
  type  = string
}

variable "geolocation_routing_config" {
  description = "List of geolocation routing configuration details."
  default     = []
  type        = list(object({
    location  = string
    rrdatas   = list(string)
  }))
}

