variable "project_id" {
  description = "The project in which the PubSub topic will be created."
  type        = string
}

variable "bucket_location" {
  description = "Location of the Cloud Function Bucket."
  type        = string
}

variable "cloudfunction_labels" {
  type        = map(any)
  description = "A set of key/value label pairs to assign to the PubSub topic."
  default     = {}
}

variable "source_file_name" {
  description = "Name of the source file including .zip in the final."
  type        = string
}

variable "source_file_path" {
  description = "Path of the file being uploaded."
  type        = string
}

variable "function_name" {
  description = "Name of the function."
  type        = string
}

variable "environment_variables" {
  description = "Cloud Function environment variables."
  type        = map(any)
}

variable "pubsub_topic_name" {
  description = "Name of the pubsub topic."
  type        = string
}

variable "function_location" {
  description = "The region in which the function will run."
  type        = string
}

variable "function_description" {
  description = "Description of the function."
  type        = string
}

variable "function_runtime" {
  description = "Programming Language of the function."
  type        = string
}

variable "function_entry_point" {
  description = "The name of a method in the function source which will be invoked when the function is executed."
  type        = string
}


variable "function_memory" {
  description = "The amount of memory available for a function. Defaults to 256M. Supported units are k, M, G, Mi, Gi. If no unit is supplied the value is interpreted as bytes"
  type        = string
  default     = "256M"
}

variable "retry_policy" {
  description = "Possible values are RETRY_POLICY_UNSPECIFIED, RETRY_POLICY_DO_NOT_RETRY, and RETRY_POLICY_RETRY.."
  type        = string
  default     = "RETRY_POLICY_DO_NOT_RETRY"
}

variable "service_account_email" {
  description = "The email of the service account for this function."
  type        = string
}

