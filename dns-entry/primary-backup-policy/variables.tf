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

variable "backup_geo_config" {
  description = "List of backup geo routing configuration details."
  default     = []
  type        = list(object({
    location  = string
    rrdatas   = list(string)
  }))
}

variable "primary_backup_trickle_ratio" {
  description = "Specifies the percentage of traffic to send to the backup targets even when the primary targets are healthy."
  type        = number
  default     = 0.1
}

variable "enable_geo_fencing_for_backups" {
  description = "Specifies whether to enable fencing for backup geo queries."
  type        = bool
  default     = true
}

variable "ILB_IP_ADDRESS" {
  description = "The frontend IP address of the load balancer."
  type  = string
}

variable "ILB_network_url" {
  description = "The fully qualified url of the network in which the load balancer belongs. Format example: projects/{project}/global/networks/{network}"
  type  = string
}

variable "ILB_project_id" {
  description = "The ID of the project in which the load balancer belongs."
  type  = string
}

variable "ILB_region" {
  description = "The region of the load balancer."
  type  = string
}
