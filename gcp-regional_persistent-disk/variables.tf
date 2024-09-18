variable "regional_disk_name" {
    description = "Name of the Regional Persistent Disk."
    type        = string
}

variable "disk_replica_zones" {
    description = "Zone of the Regional Persistent Disk."
    type        = list(string)
}

variable "regional_disk_description" {
    description = "Description for the Regional Persistent Disk."
    type        = string
}

variable "regional_disk_labels" {
    description = "Key-value map of labels to assign to the Regional Persistent Disk."
    type        = map(any)
    default     = {}
}

variable "regional_disk_size" {
    description = "Size of the Regional Regional Persistent Disk."
    type        = number
}

variable "regional_disk_type" {
    description = "Type of the Regional Regional Persistent Disk."
    type        = string
    default     = "pd-ssd"
}

variable "disk_region" {
    description = "Region of the Regional Persistent Disk."
    type        = string
}

variable "regional_disk_project_id" {
    description = "The ID of the project in which the resource belongs. If it is not provided, the provider project is used."
    type        = string
}

variable "kms_key_name" {
    description = "They encryption key to be used for the Disk."
    type        = string
    default     = null
}

variable "use_encryption_key" {
    description = "Choose if a disk encryption key will be used or not."
    type        = bool
}
