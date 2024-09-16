output "static_internal_ip_address" {
  value       = google_compute_address.internal_static_ip.address
  description = "The generated static internal IP address for the VM instance"
}