variable "custom_role_id" {
  type        = string
  description = "ID of the Custom Role."
}

variable "custom_role_title" {
  type        = string
  description = "Human-readable title of the Custom Role, defaults to role_id."
  default     = ""
}

variable "custom_role_permissions" {
  type        = list(string)
  description = "IAM permissions assigned to Custom Role."
}

variable "custom_role_description" {
  type        = string
  description = "Description of Custom role."
  default     = ""
}

variable "stage" {
  type        = string
  description = "The current launch stage of the role. Defaults to GA."
  default     = "GA"
}

variable "project_id" {
  type        = string
  description = "Variable for project or organization ID."
}


variable "members" {
  description = "List of members to be added to custom role."
  type        = list(string)
}