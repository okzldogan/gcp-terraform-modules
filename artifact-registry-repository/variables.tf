variable "location" {
  description = "Location of the repo. 'asia', 'europe' or 'us' for multi-region"
  type  = string
}

variable "repo_id" {
  description = "Name or ID of the repo being created."
  type        = string
}

variable "description" {
  description = "Description of the repo."
  type        = string
}

variable "repo_type" {
  description = "Format or type of the repo."
  type        = string
}

variable "project_id" {
  description = "Project ID in which the repo will reside."
  type        = string
}

variable "kms_key_name" {
  description   = "Key to encrypt & decrypt the repo."
  type          = string
  default       = null
}

variable "labels" {
    description = "Key-value map of labels to assign to the repo."
    type        = map(any)
    default     = {}
}

variable "iam_bindings" {
  description = "Map of role (key) and list of members (value) to add the IAM policies/bindings"
  type        = map(list(string))
  default     = {}
}