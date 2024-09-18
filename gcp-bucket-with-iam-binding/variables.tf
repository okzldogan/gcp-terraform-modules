variable "project_id" {
  description = "Project ID in which the repo will reside."
  type        = string
}

variable "bucket_id" {
  description   = "Purpose of the bucket"
  type          = string
}

variable "bucket_location" {
  description = "Location of the bucket. 'EU' for EU member states or 'EUROPE-WEST1' for Belgium and 'EUROPE-NORTH1' for Finland."
  type        = string
}

variable "public_access_prevention" {
  type        = string
  description = " Prevents public access to a bucket. Acceptable values are inherited or enforced. If inherited, the bucket uses public access prevention. only if the bucket is subject to the public access prevention organization policy constraint. Defaults to inherited."
  default     = "enforced"
}

# Storage Class Supported Values
# STANDARD, NEARLINE, COLDLINE, ARCHIVE

variable "storage_class" {
  description   = "The Storage Class of the bucket."
  type          = string
  default       = "STANDARD"
}

variable "force_destroy" {
  description = "When deleting a bucket, this boolean option will delete all contained objects. If you try to delete a bucket that contains objects, Terraform will fail that run."
  type        = bool
}

variable "bucket_labels" {
  type        = map(any)
  description = "A set of key/value label pairs to assign to the bucket."
  default     = {}
}

variable "dual_region" {
  description = "A Cloud KMS key that will be used to encrypt objects inserted into this bucket"
  type = object({
    data_locations = list(string)
  })
  default = null
}

variable "versioning" {
  description   = "While set to true, autoclass automatically transitions objects in your bucket to appropriate storage classes based on each object's access pattern."
  type          = bool
  default       = false
}

variable "bindings" {
  description = "Map of role (key) and list of members (value) to add the IAM policies/bindings"
  type        = map(list(string))
  default     = {}
}

variable "condition" {
  type      = any
  default   = null
}

variable "cors_config" {
  type      = any
  default   = {}
}

variable "bucket_folders" {
  description   = "While set to true, autoclass automatically transitions objects in your bucket to appropriate storage classes based on each object's access pattern."
  type          = list(string)
  default       = []
}

variable "lifecycle_rules" {
  description = "The bucket's Lifecycle Rules configuration."
  type = set(object({
    # Object with keys:
    # - type - The type of the action of this Lifecycle Rule. Supported values: Delete and SetStorageClass.
    # - storage_class - (Required if action type is SetStorageClass) The target Storage Class of objects affected by this Lifecycle Rule.
    action = map(string)

    # Object with keys:
    # - age - (Optional) Minimum age of an object in days to satisfy this condition.
    # - created_before - (Optional) Creation date of an object in RFC 3339 (e.g. 2017-06-13) to satisfy this condition.
    # - with_state - (Optional) Match to live and/or archived objects. Supported values include: "LIVE", "ARCHIVED", "ANY".
    # - matches_storage_class - (Optional) Storage Class of objects to satisfy this condition. Supported values include: MULTI_REGIONAL, REGIONAL, NEARLINE, COLDLINE, STANDARD, DURABLE_REDUCED_AVAILABILITY.
    # - num_newer_versions - (Optional) Relevant only for versioned objects. The number of newer versions of an object to satisfy this condition.
    condition = map(string)
  }))
  default = []
}