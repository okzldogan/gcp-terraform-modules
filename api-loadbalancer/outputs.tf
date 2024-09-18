output "lb_public_ip_addres" {
    description = "IP Address of the Load Balancer"
    value       = google_compute_global_address.lb_public_ip_addres.id
}