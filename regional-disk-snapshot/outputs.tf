output "regional_disk_snapshot_policy" {
  value       = google_compute_resource_policy.regional_disk_snapshot_policy
  description = "The Regional disk snapshot policy."
}

output "regional_disk_snapshot_policy_attachment" {
  value       = google_compute_region_disk_resource_policy_attachment.attachment
  description = "The Regional disk snapshot policy attachment."
}