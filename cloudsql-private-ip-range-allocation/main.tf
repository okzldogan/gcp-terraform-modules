resource "google_compute_global_address" "cloudsql_ip_range" {


    name            = var.range_name
    description     = var.description
    address_type    = "INTERNAL"
    ip_version      = "IPV4"
    project         = var.project_id

    network         = var.network
    prefix_length   = var.prefix_length
    purpose         = "VPC_PEERING"
    address         = var.ip_address
}