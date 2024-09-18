
variable "description" {
  description = "Dataset description."
  type        = string
  default     = null
}


variable "bq_table_deletion_protection" {
  description = "Whether or not to allow Terraform to destroy the instance. Unless this field is set to false in Terraform state, a terraform destroy or terraform apply that would delete the instance will fail"
  type        = bool
  default     = false
}

variable "project_id" {
  description = "Project where the dataset and table are created"
  type        = string
}

variable "bq_dataset_id" {
  description = "BigQuery Dataset ID in which the table will be created."
  type        = string
}

variable "materialized_views" {
  description = "Materialized view config for each Materialized view in the specified dataset."
  type        = any
  default     = []
}
