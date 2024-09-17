variable "key_ring_name" {
  description = "Name of the key ring."
  type        = string
}

variable "key_ring_location" {
  description = "Region or multi-region name. For example 'europe' or 'europe-west1' or 'global'. "
  type        = string
}

variable "project_id" {
  description = "Project ID of the key ring."
  type        = string
}

variable "key_name" {
  description = "Name of the key."
  type        = string
}

variable "key_labels" {
  type        = map(any)
  description = "A set of key/value label pairs to assign to the key."
  default     = {}
}

variable "key_purpose" {
  description = "Possible values are 'CRYPTO_KEY_PURPOSE_UNSPECIFIED', 'ENCRYPT_DECRYPT', 'ASYMMETRIC_SIGN', 'ASYMMETRIC_DECRYPT' or 'MAC' ."
  type        = string
  default     = "ENCRYPT_DECRYPT"
}

variable "key_rotation_period" {
  description = "Every time this period passes, generate a new CryptoKeyVersion and set it as the primary. Value followed by the letter s (seconds) example: 7776000s for 90 days ."
  type        = string
  default     = "7776000s"
}

variable "key_generation_algorithm" {
  type        = string
  description = "The algorithm to use when creating a version based on this template. See the https://cloud.google.com/kms/docs/reference/rest/v1/CryptoKeyVersionAlgorithm for possible inputs."
  default     = "GOOGLE_SYMMETRIC_ENCRYPTION"
}

variable "encryption_method" {
  description = "The protection level to use when creating a version based on this template. Possible values include 'SOFTWARE', 'HSM', 'EXTERNAL', 'EXTERNAL_VPC'. Defaults to 'SOFTWARE' . "
  type        = string
  default     = "SOFTWARE"
}

variable "key_iam_bindings" {
  description = "Map of role (key) and list of members (value) to add the IAM policies/bindings"
  type        = map(list(string))
  default     = {}
}
