variable "name" {
    description = "Name of the public ip."
    type        = string
}

variable "internal_ip_address" {
    description = "Internal IP Address to be reserved in the subnet."
    type        = string
}

variable "description" {
    description = "Description of the IP range being created."
    type        = string
}

variable "subnet" {
    description = "Subnet in which the IP will be reserved."
    type        = string
}

variable "region" {
    description = "The subnet's region."
    type        = string
}

variable "project_id" {
    description = "Project name in which the IP range will be created."
    type        = string
}

