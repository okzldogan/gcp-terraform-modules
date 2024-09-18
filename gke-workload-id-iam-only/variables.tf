variable "cluster_project" {
  description = "The project ID in which the GKE cluster resides."
  type        = string
}

variable "gcp_sa_id" {
  description = "The Service Account ID"
  type        = string
}

variable "gke_sa_binding" {
  description = "The name given in GKE kubernetes service account to bind with the GCP Service Account"
  type        = map
}






