variable "gcp_service_account_name" {
  description = "Name for both service accounts. The GCP SA will be truncated to the first 30 chars if necessary."
  type        = string
}

variable "gcp_service_account_display_name" {
  description = "Name for the Google service account; overrides `var.name`."
  type        = string
}

variable "project_id" {
  description = "GCP project ID"
  type        = string
}

variable "description" {
  description = "Description of the service account being created."
  type        = string
}

variable "cluster_project_name" {
  description = "The project ID in which the GKE cluster resides."
  type        = string
}

variable "gke_namespace" {
  description = "GKE namespace in which the service account will be used."
  type        = string
}

variable "k8s_sa_name" {
  description = "The name given in GKE kubernetes service account to bind with the GCP Service Account"
  type        = string
}






