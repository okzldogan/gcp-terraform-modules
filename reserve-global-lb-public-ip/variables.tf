variable "name" {
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
    default     = null
}

