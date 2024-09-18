resource "google_compute_region_disk_resource_policy_attachment" "attachment" {
  name    = google_compute_resource_policy.regional_disk_snapshot_policy.name
  disk    = var.regional_disk_name
  region  = var.disk_region
  project = var.disk_project_id
}


resource "google_compute_resource_policy" "regional_disk_snapshot_policy" {
  name = var.regional_disk_snapshot_policy_name
  region = var.disk_region
  snapshot_schedule_policy {
    retention_policy {
      max_retention_days = var.max_retention_days 
      on_source_disk_delete = var.retention_method_after_source_disk_deletion # string KEEP_AUTO_SNAPSHOTS ( snapshots are retained permanently) or APPLY_RETENTION_POLICY ( keep snapshots as specificed in max_retention_days)
    }

    snapshot_properties {
      labels            = var.disk_snapshot_labels 
      storage_locations = var.snapshot_cloud_storage_locations 
      chain_name        = var.snapshot_chain_name
    }
    dynamic "schedule" {
      for_each  = var.schedule_type == "daily_schedule" || var.schedule_type == "hourly_schedule" || var.schedule_type == "weekly_schedule" ? [1] : []

      content {
        dynamic "daily_schedule" {
          for_each  = var.schedule_type == "daily_schedule" ? [1] : []
          content {
            days_in_cycle = var.number_of_days_between_daily_snapshots 
            start_time    = var.daily_schedule_start_time
          }
        }

        dynamic "hourly_schedule" {
          for_each  = var.schedule_type == "hourly_schedule" ? [1] : []
          content {
            hours_in_cycle = var.hours_in_cycle
            start_time    = var.hourly_schedule_start_time
          }
        }

        dynamic "weekly_schedule" {
          for_each  = var.schedule_type == "weekly_schedule" ? [1] : []
          content {
            day_of_weeks {
              start_time = var.weekly_snapshot_start_time
              day = var.day_of_the_week_for_snapshot
            }
          }
        }

      }


    }
  }
}

