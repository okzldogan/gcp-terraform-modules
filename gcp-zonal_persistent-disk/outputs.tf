output "gcp_persistent_disk" {
  value       = google_compute_disk.zonal_persistent_disk
  description = "The created Persistent Disk"
}