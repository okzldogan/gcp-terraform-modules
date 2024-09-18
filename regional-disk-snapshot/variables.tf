variable "regional_disk_name" {
    description = "Name of the Persistent Disk."
    type        = string
}

variable "disk_zone" {
    description = "Zone of the Persistent Disk."
    type        = string
}

variable "disk_project_id" {
    description = "The ID of the project in which the resource belongs. If it is not provided, the provider project is use."
    type        = string
}


variable "regional_disk_snapshot_policy_name" {
    description = "Name of the Regional Snapshot Policy."
    type        = string
}

variable "disk_region" {
    description = "Region of the Snapshot Policy."
    type        = string
}


variable "schedule_type" {
    description = "Schedule type."
    type        = string
}

variable "daily_schedule_start_time" {
    description = "Daily Snapshot start time."
    type        = string
    default     = null
}

variable "number_of_days_between_daily_snapshots" {
    description = "The number of days between dailiy snapshots."
    type        = number
    default     = null
}

variable "hours_in_cycle" {
    description = "The number of hours between snapshots."
    type        = number
    default     = null
}

variable "hourly_schedule_start_time" {
    description = "Time within the window to start the operations."
    type        = string
    default     = null
}

variable "weekly_snapshot_start_time" {
    description = "The number of hours between snapshots."
    type        = string
    default     = null
}

variable "day_of_the_week_for_snapshot" {
    description = "Day of the week to make the weekly snapshot."
    type        = string
    default     = null
}

variable "max_retention_days" {
    description = "The number of days to keep the snapshot."
    type        = number
}

variable "retention_method_after_source_disk_deletion" {
    description = "Two options: KEEP_AUTO_SNAPSHOTS ( snapshots are retained permanently) or APPLY_RETENTION_POLICY ( keep snapshots as specificed in max_retention_days)."
    type        = string
    default     = "KEEP_AUTO_SNAPSHOTS"
}

variable "disk_snapshot_labels" {
    description = "Key-value map of labels to assign to the Persistent Disk."
    type        = map(any)
    default     = {}
}

variable "snapshot_cloud_storage_locations" {
    description = "Key-value map of labels to assign to the Persistent Disk."
    type        = list(string)
    default     = [
        "europe",
    ]
}

variable "snapshot_chain_name" {
    description = "Snapshot name prefix"
    type        = string
}



