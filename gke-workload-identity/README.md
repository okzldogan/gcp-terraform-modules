This module creates a service account and later grants the service account GKE Workload ID permission to be used in a specific namespace in the indicated GKE cluster.


######################################
##### Example Use of the Module ######
######################################

module "gke_my_app_sa" {
    source          = "../../../terraform-modules/gke-workload-identity/"

    gcp_service_account_name            = "sa-gke-my-app"
    gcp_service_account_display_name    = "Service Account MY-NAMESPACE for accesing GCP Resources"
    project_id                          = "<project-id>"
    description                         = "Service Account for accessing GCP resources from MY-NAMESPACE in the MY-CLUSTER-NAME cluster"

    cluster_project_name                = "gke-hosting-project"
    gke_namespace                       = "my-namespace"
    k8s_sa_name                         = "my-app-sa"


}