variable "project_id" {
  description = "Project id for the zone."
  type        = string
}


variable "pubsub_user_service_account" {
  description = "pubsub.publisher and pubsub.subscriber service account"
  type        = string
}

variable "topic_name" {
  description = "Topic Name"
  type        = string
}


variable "labels" {
  description = "Resource labels."
  type        = map(string)
  default     = {}
}

variable "subscription_config" {
  description = "Subscription parameters"
  type        = list(map(string))
}

