variable "logging_bucket_project_id" {
  description = "Logging Bucket's Project ID."
  type        = string
}

variable "logging_bucket_location" {
  description = "Location of the logging bucket."
  type        = string
  default     = "europe-west1" 
}

variable "log_retention_days" {
  description = "Insert the required retention in days."
  type        = number
  default     = 90
}

variable "logging_bucket_id" {
  description = "Name of the logging bucket to be created."
  type        = string
}

variable "logging_bucket_description" {
  description = "Description for both logging bucket and sink."
  type        = string
}

variable "encrypt_logs" {
    description = "Set true to encrpyt the logging bucket."
    type        = bool
}

variable "logging_bucket_encryption_key" {
    description = "They encryption key to be used for the logging bucket."
    type        = string
    default     = null
}

variable "log_sink_name" {
  description = "Name of the log sink to be created."
  type        = string
}

variable "k8s_namespace" {
  description = "Kubernetes namespace from which the logs will be exported."
  type        = string
}

variable "sink_host_project" {
  description = "The project in which the logs are exported."
  type        = string
}







