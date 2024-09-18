variable "project_id" {
  description = "The project ID where the IAM binding is to be applied"
  type        = string
}

variable "roles" {
  description ="The list of Roles to be assigned"
  type = list(string)
}

variable "members" {
  description ="The list of members for the roles to be assigned"
  type = list(string)
}

variable "condition" {
  type = any
  default = null
}

