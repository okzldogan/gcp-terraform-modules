# Create the VPC 

resource "google_compute_network" "vpc_network" {
  name                    = var.name
  project                 = var.project
  description             = var.description
  routing_mode            = var.routing_mode
  auto_create_subnetworks = var.auto_create_subnetworks
  mtu                     = var.mtu
}

# A host project provides network resources to associated service projects.
resource "google_compute_shared_vpc_host_project" "vpc_host_project" {
    provider    = google-beta
    project     = google_compute_network.vpc_network.project
    depends_on  = [
      google_compute_network.vpc_network
    ]
}

