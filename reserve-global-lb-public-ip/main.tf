resource "google_compute_global_address" "public_ip_address" {

    provider        = google-beta

    name            = var.name
    description     = var.description
    address_type    = "EXTERNAL"
    ip_version      = "IPV4"
    project         = var.project_id

    network         = var.network
}