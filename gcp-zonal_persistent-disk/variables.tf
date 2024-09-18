variable "disk_name" {
    description = "Name of the Persistent Disk."
    type        = string
}

variable "disk_description" {
    description = "Description for the Persistent Disk."
    type        = string
}

variable "disk_labels" {
    description = "Key-value map of labels to assign to the Persistent Disk."
    type        = map(any)
    default     = {}
}

variable "disk_size" {
    description = "Size of the Persistent Disk."
    type        = number
}

variable "disk_type" {
    description = "Name of the Persistent Disk."
    type        = string
    default     = "pd-ssd"
}

variable "disk_zone" {
    description = "Zone of the Persistent Disk."
    type        = string
}

variable "kms_key_self_link" {
    description = "They encryption key to be used for the Disk."
    type        = string
    default     = null
}

variable "use_encryption_key" {
    description = "Choose if a disk encryption key will be used or not."
    type        = bool
}

variable "disk_project_id" {
    description = "The ID of the project in which the resource belongs. If it is not provided, the provider project is use."
    type        = string
}

variable "provisioned_iops" {
    description = "Indicates how many IOPS must be provisioned for the disk."
    type        = number
    default     = null
}

variable "multi_writer" {
    description = "Choose if a disk encryption key will be used or not."
    type        = bool
    default     = null
}