variable "bucket_name" {
  type = string
  description = "Name of the bucket"
}

variable "bindings" {
  description = "Map of role (key) and list of members (value) to add the IAM policies/bindings"
  type        = map(list(string))
  default     = {}
}

variable "condition" {
  type = any
  default = null
}