output "allocated_ip_range_name" {
  value       = google_compute_global_address.cloudsql_ip_range.name
  description = "The name of the generated ip range"
}