variable "filestore_instance_name" {
  description = "Name of the filestore instance."
  type        = string
}

### File Store Tier Possible Values:
### STANDARD, PREMIUM, BASIC_HDD, BASIC_SSD, 
### HIGH_SCALE_SSD and ENTERPRISE

variable "filestore_tier" {
  description = "Tier of the filestore instance."
  type        = string
}

variable "project_id" {
  description = "Project id of the filestore instance."
  type        = string
}

variable "filestore_vpc_network" {
  description = "Network of the filestore instance."
  type        = string
}


variable "filestore_ip_range" {
  description = "Reserved ip range for the filestore instance."
  type        = string
}


variable "fileshare_name" {
  description = "File system share on the instance."
  type        = string
}

variable "filestore_capacity" {
  description = "File share capacity in GiB. This must be at least 1024 GiB for the standard tier, or 2560 GiB for the premium tier."
  type        = number
}

variable "nfs_access_config" {
    description = "NFS Access Configuration"
    type        = any
}

variable "filestore_description" {
  description = "Description for the Filestore Instance."
  type        = string
}

variable "filestore_labels" {
    description = "Key-value map of labels to assign to the Filestore instance."
    type        = map(any)
    default     = {}
}

variable "filestore_location" {
  description = "The name of the location of the instance. This can be a region for ENTERPRISE tier instances."
  type        = string
}

variable "kms_key_name" {
  description = "KMS key name used for data encryption."
  type        = string
  default     = null
}



