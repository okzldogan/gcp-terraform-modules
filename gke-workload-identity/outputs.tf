
output "gcp_service_account_id" {
  description = "Name of GCP service account."
  value       = google_service_account.gke_workload_id_service_account.id
}

output "gcp_service_account_email" {
  description = "Name of GCP service account."
  value       = google_service_account.gke_workload_id_service_account.email
}
