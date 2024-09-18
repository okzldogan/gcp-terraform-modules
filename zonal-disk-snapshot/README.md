This module creates a snapshot policy for a zonal disk.

######################################
##### Example Use of the Module ######
######################################


module "zonal_disk_snapshot_policy" {
    source          = "../../../terraform-modules/zonal-disk-snapshot/"         

    disk_name           = "gke-test-nfs"
    disk_zone           = "europe-west1-c"
    disk_project_id     = "<project-id>"

    disk_snapshot_policy_name   = "once-a-week-friday"

    disk_region         = "europe-west1"

    schedule_type       = "weekly_schedule"

    weekly_snapshot_start_time      = "01:00"
    day_of_the_week_for_snapshot    = "FRIDAY"


    snapshot_chain_name = "gke-test-nfs-"

    retention_method_after_source_disk_deletion = "APPLY_RETENTION_POLICY"
    max_retention_days  = 30

    snapshot_cloud_storage_locations = [
        "europe-west1"          # single region can be modified to multi-region as "europe"
    ]

}
