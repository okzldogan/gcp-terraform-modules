
resource "google_compute_address" "internal_static_ip" {
    
    name         = var.name
    address      = var.internal_ip_address
    address_type = "INTERNAL"
    description  = var.description
    purpose      = "GCE_ENDPOINT"
    subnetwork   = var.subnet
    region       = var.region

    project      = var.project_id
}