variable "range_name" {
    description = "Name of the public ip."
    type        = string
}

variable "description" {
    description = "Description of the IP range being created."
    type        = string
}

variable "project_id" {
    description = "Project name in which the IP range will be created."
    type        = string
}

variable "network" {
    description = "Fully qualified network name."
    type        = string
}

variable "ip_address" {
    description = "IP address without the prefix (for example /24 or /16) "
    type        = string
}

variable "prefix_length" {
    description = "IP address prefix (for example 24 for /24) "
    type        = number
}

