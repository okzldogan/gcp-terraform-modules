variable "bq_dataset_id" {
    description = "ID of BigQuery Dataset."
    type        = string
}

variable "dataset_descriptive_name" {
    description = "Descriptive Name for the BiqQuery Dataset."
    type        = string
}

variable "bq_dataset_description" {
    description = "Description of the BigQuery Dataset"
    type        = string
}

variable "bq_dataset_location" {
    description = "Location of the BigQuery Dataset. For Multi-Region use EU"
    type        = string
    default     = "europe-west1"
}

variable "bigquery_dataset_bindings" {
  description = "Map of role (key) and list of members (value) to add the IAM policies/bindings"
  type        = map(list(string))
  default     = {}
}

variable "project_id" {
    description = "Project of the BQ Dataset that being created"
    type        = string
}

variable "delete_contents_on_destroy" {
    description = "If set to true, delete all the tables in the dataset when destroying the resource; otherwise, destroying the resource will fail if tables are present"
    type        = bool
}

variable "use_encryption_key" {
    description = "If set to true, pass the kms_key_name value"
    type        = bool
}

variable "kms_key_name" {
    description = "They encryption key to be used for the BigQuery Dataset."
    type        = string
    default     = null
}

variable "storage_billing_model" {
    description = "Specifies the storage billing model for the dataset. Set this flag value to LOGICAL to use logical bytes for storage billing, or to PHYSICAL to use physical bytes instead. LOGICAL is the default if this flag isn't specified."
    type        = string
    default     = "LOGICAL"
}

variable "data_recovery_time" {
    description = "ou can access data from any point within the time travel window, which covers the past seven days by default. Time travel lets you query data that was updated or deleted, restore a table that was deleted, or restore a table that expired."
    type        = string
    default     = "168" # 7 days
}

variable "dataset_expiration_time" {
    description = "Dataset tables expiration time in miliseconds"
    type        = string
    default     = "7884000000" # 3 months
}

variable "dataset_labels" {
    description = "Key-value map of labels to assign to the BQ Dataset."
    type        = map(any)
    default     = {}
}
