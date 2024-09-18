output "filestore_allocated_ip_range_name" {
  value       = google_compute_global_address.filestore_ip_range.name
  description = "The name of the generated ip range for Filestore Instance."
}