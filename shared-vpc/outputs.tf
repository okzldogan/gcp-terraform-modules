output "shared_vpc_id" {
  value       = google_compute_network.vpc_network.id
  description = "The created Shared VPC resource"
}