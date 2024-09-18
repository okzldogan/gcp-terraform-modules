variable "project_id" {
  description = "Project id for the zone."
  type        = string
}


variable "pubsub_user_service_account" {
  description = "pubsub.publisher and pubsub.subscriber service account"
  type        = string
}


variable "labels" {
  description = "Resource labels."
  type        = map(string)
  default     = {}
}

variable "pubsub_config" {
  description = "Pubsub configuration parameters"
  type        = map(list(string))
}

