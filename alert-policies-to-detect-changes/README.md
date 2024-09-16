This module creates four custom metrics for changes in cloud sql instance's users and whether an instance is stopped, deleted or created in the indicated GCP project.

Moreover it also checks for secrets created outside of defined replication regions.

Later the changes are monitored via alert policies for each.

######################################
##### Example Use of the Module ######
######################################

module "gcp_project_detect_changes_alerts" {
    source          = "../../terraform-modules/alert-policies-to-detect-changes/"

    project_id                        = "my-project"
    logging_bucket_name               = "my-logging-bucket"
    monitored_gcp_project             = "monitored-gcp-project"

    environment                       = "prod"

    alert_notification_channels       = [
        google_monitoring_notification_channel.cloud_infra_notification_channel.name
    ]

    link_to_logs                  = "add-link-to-logs-here"


}
