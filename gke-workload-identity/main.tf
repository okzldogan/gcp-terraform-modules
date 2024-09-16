resource "google_service_account" "gke_workload_id_service_account" {

    account_id      = var.gcp_service_account_name
    display_name    = var.gcp_service_account_display_name
    project         = var.project_id

    description     = var.description

}

resource "google_service_account_iam_member" "gke_workload-id-sa" {
  service_account_id = google_service_account.gke_workload_id_service_account.id
  role               = "roles/iam.workloadIdentityUser"
  member             = "serviceAccount:${var.cluster_project_name}.svc.id.goog[${var.gke_namespace}/${var.k8s_sa_name}]"

  depends_on = [
    google_service_account.gke_workload_id_service_account
  ]
}
