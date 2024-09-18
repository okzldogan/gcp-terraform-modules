output "zonal_disk_snapshot_policy" {
  value       = google_compute_resource_policy.zonal_disk_snapshot_policy
  description = "The Zonal disk snapshot policy."
}

output "zonal_disk_snapshot_policy_attachment" {
  value       = google_compute_disk_resource_policy_attachment.attachment
  description = "The Zonal disk snapshot policy attachment."
}