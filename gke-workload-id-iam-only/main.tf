resource "google_service_account_iam_member" "gke_workload_id_sa_binding" {
    for_each           = var.gke_sa_binding

    service_account_id = var.gcp_sa_id
    role               = "roles/iam.workloadIdentityUser"
    member             = "serviceAccount:${var.cluster_project}.svc.id.goog[${each.key}/${each.value}]"

}