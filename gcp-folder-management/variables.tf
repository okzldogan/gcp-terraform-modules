variable "folder_name" {
  description = "Name of the Folder."
  type        = string
}

variable "parent" {
  description = "The organizational structure in which the folder will be created. "
  type        = string
  default     = "organizations/100406087984" # South Pole Organization ID
}

variable "folder_iam_bindings" {
  description = "Map of role (key) and list of members (value) to add the IAM policies/bindings"
  type        = map(list(string))
  default     = {}
}


