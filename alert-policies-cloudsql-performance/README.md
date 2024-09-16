This module creates alert policies ( in total three alert policies) for CloudSQL on CPU & RAM Utilization over 90% and Postgresql Connections at 80% of capacity.

 ######################################
 ##### Example Use of the Module ######
 ######################################


module "cloudsql_alerts" {
    source          = "../../terraform-modules/alert-policies-cloudsql-performance/"

    cloudsql_project_reference      = "MY PROJECT REFERENCE"
    project_id                      = "my-project"

    cloudsql_db_id                  = "my-project-name:my-db-instance"

    notification_channels           = [
        "projects/my-project/notificationChannels/<channel-id>"
    ]

    alert_auto_close                = "7200s"

    active_connections_threshold    = "160"      # Set the threshold for active connections
    max_active_connections          = "200"     # Set the maximum active connections


}
