output "global_lb_ip_address" {
  value       = google_compute_global_address.public_ip_address.address
  description = "The generated IP address for the External Global LB"
}