This module creates five custom metrics for changes in IAM permissions and custom roles as well as whether a Cloud SQL db is launched in GKE hosting GCP projects.

Moreover it also checks for secrets created outside of defined replication regions.

Later the changes are monitored via alert policies for each.

######################################
##### Example Use of the Module ######
######################################

module "sp_gke_prod_detect_changes_alerts" {
    source          = "../../terraform-modules/gke-alert-policies-to-detect-changes/"

    project_id                        = "${var.prefix}-${var.name}"
    logging_bucket_name               = module.sp_gke_prod_audit_logs_export.logging_bucket_id
    monitored_gcp_project             = "sp-gke-prod"

    environment                       = "prod"

    alert_notification_channels       = [
        google_monitoring_notification_channel.infra_mail.name
    ]

    link_to_logs                  = "https://console.cloud.google.com/logs/query;storageScope=storage,projects%2Fsp-central-monitoring%2Flocations%2Feurope-west1%2Fbuckets%2Faudit-logs-export-sp-gke-prod%2Fviews%2F_AllLogs;duration=P1D?project=sp-central-monitoring"

    depends_on = [
        google_monitoring_notification_channel.infra_mail,
        module.sp_gke_prod_audit_logs_export
    ]


}