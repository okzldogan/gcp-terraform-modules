
This module creates a GKE workload identity binding for a GCP service account for multiple namespaces in a GKE cluster.

###################################################################
### GKE Workload ID Mapping for the Remaining DEV Namespaces  #####
###################################################################

module "gke_workload_id_sa_binding" {
    source          = "../../../terraform-modules/gke-workload-id-iam-only/"

    gcp_sa_id            = "my-gcp-service-account-id"
    cluster_project      = "my-gke-cluster"

    gke_sa_binding = {
        # Namespace         |     K8s SA Name
        my-app-backend      = "my-backend-app-sa"
        my-other-namespace  = "my-other-k8s-sa"
        my-namespace        = "my-namespace-k8s-sa"
    }

}