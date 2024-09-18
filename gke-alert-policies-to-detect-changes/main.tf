

##########################################################################
### Create Custom Logging Metric for Cloud SQL Instance Modifications ####
##########################################################################

resource "google_logging_metric" "cloudsql_instance_modifications" {
    
    name            = "${var.monitored_gcp_project}-cloudsql-instance-modified"
    filter          = "protoPayload.methodName=\"cloudsql.instances.update\" OR protoPayload.methodName=\"cloudsql.instances.create\" OR protoPayload.methodName=\"cloudsql.instances.delete\" ${var.cloudsql_modifications_optional_condition}"

    project         = var.project_id

    bucket_name     = var.logging_bucket_name

    metric_descriptor {

        unit            = "1"
        value_type      = "INT64"
        metric_kind     = "DELTA"
        display_name    = "${var.monitored_gcp_project} Cloud SQL Instance Modified"
    }

}




###################################################################################
### Create Alert Policy for Cloud SQL DB Instance Changes Outside Terraform #######
###################################################################################


resource "google_monitoring_alert_policy" "monitor_cloudsql_instance_changes" {

    display_name            = "Changes occured for Cloud SQL instance in ${var.monitored_gcp_project}"

    project                 = var.project_id

    enabled                 = true

    notification_channels   = var.alert_notification_channels

    alert_strategy {
        auto_close = "3600s" # 1 hour
    }

    # severity = "CRITICAL"     # Uncomment when using provider version > 5.11.0

    combiner = "OR"

    conditions {

        condition_threshold {

            aggregations {
                alignment_period     = "60s"
                cross_series_reducer = "REDUCE_SUM"
                per_series_aligner   = "ALIGN_SUM"
            }

            comparison = "COMPARISON_GT"
            duration   = "60s"
            filter     = "resource.type = \"logging_bucket\" AND metric.type = \"logging.googleapis.com/user/${var.monitored_gcp_project}-cloudsql-instance-modified\""

            trigger {
                count = 1
            }

        }

        display_name = "Cloud SQL Instance created, deleted, updated or stopped outside Terraform IaC in ${var.monitored_gcp_project}"
    }

    documentation {
        content   = "Cloud SQL Instance created, deleted, updated or stopped outside Terraform IaC in ${var.monitored_gcp_project}.\n\nPlease check logs in the ${var.project_id} project:\n\n${var.link_to_logs}"
        mime_type = "text/markdown"
    }

    depends_on = [
        google_logging_metric.cloudsql_instance_modifications,
        null_resource.delay
    ]

}



###########################################################################################
### Create Custom Logging Metric for Secret Creation Out of Primary & Secondary Region ####
###########################################################################################

resource "google_logging_metric" "secret_creation_regions_prod" {

    count           = var.environment == "prod" ? 1 : 0
    
    name            = "${var.monitored_gcp_project}-secret-creation-outside-defined-replication-regions"
    filter          = "protoPayload.methodName=\"google.cloud.secretmanager.v1.SecretManagerService.CreateSecret\" AND NOT protoPayload.request.secret.replication.userManaged.replicas.location=\"europe-west1\" AND protoPayload.request.secret.replication.userManaged.replicas.location=\"europe-north1\""

    project         = var.project_id

    bucket_name     = var.logging_bucket_name

    metric_descriptor {

        unit            = "1"
        value_type      = "INT64"
        metric_kind     = "DELTA"
        display_name    = "${var.monitored_gcp_project} Secret Creation Outside Defined Replication Regions"
    }

}

resource "google_logging_metric" "secret_creation_regions_non_prod" {

    count           = var.environment != "prod" ? 1 : 0
    
    name            = "${var.monitored_gcp_project}-secret-creation-outside-primary-region"
    filter          = "protoPayload.methodName=\"google.cloud.secretmanager.v1.SecretManagerService.CreateSecret\" AND NOT protoPayload.request.secret.replication.userManaged.replicas.location=\"europe-west1\""

    project         = var.project_id

    bucket_name     = var.logging_bucket_name

    metric_descriptor {

        unit            = "1"
        value_type      = "INT64"
        metric_kind     = "DELTA"
        display_name    = "${var.monitored_gcp_project} Secret Creation Outside Primary Replication Region"
    }

}

########################################################################################
### Create Alert Policy for Secret Creation Outside Defined Replication Regions  #######
########################################################################################

resource "null_resource" "before" {
}

resource "null_resource" "delay" {
  provisioner "local-exec" {
    command = "sleep 15"
  }
  triggers = {
    "before" = "${null_resource.before.id}"
  }
}

resource "google_monitoring_alert_policy" "secret_creation_outside_prod_regions" {

    count                   = var.environment == "prod" ? 1 : 0

    display_name            = "Secret Created in ${var.monitored_gcp_project} Outside Regions europe-west1 and/or europe-north1."

    project                 = var.project_id

    enabled                 = true

    notification_channels   = var.alert_notification_channels

    alert_strategy {
        auto_close = "3600s" # 1 hour
    }

    # severity = "WARNING"      # Uncomment when using provider version > 5.11.0

    combiner = "OR"

    conditions {

        condition_threshold {

            aggregations {
                alignment_period     = "60s"
                cross_series_reducer = "REDUCE_SUM"
                per_series_aligner   = "ALIGN_SUM"
            }

            comparison = "COMPARISON_GT"
            duration   = "60s"
            filter     = "resource.type = \"logging_bucket\" AND metric.type = \"logging.googleapis.com/user/${var.monitored_gcp_project}-secret-creation-outside-defined-replication-regions\""

            trigger {
                count = 1
            }

        }

        display_name = "Secret Created outside primary & secondary regions in ${var.monitored_gcp_project}"
    }

    documentation {
        content   = "Secret Created outside primary & secondary regions in ${var.monitored_gcp_project}.\n\nPlease check logs in the ${var.project_id} project:\n\n${var.link_to_logs}"
        mime_type = "text/markdown"
    }

    depends_on = [
        google_logging_metric.secret_creation_regions_prod,
        null_resource.delay
    ]

}

resource "google_monitoring_alert_policy" "secret_creation_outside_primary_region" {

    count                   = var.environment != "prod" ? 1 : 0

    display_name            = "Secret Created in ${var.monitored_gcp_project} Outside Region europe-west1."

    project                 = var.project_id

    enabled                 = true

    notification_channels   = var.alert_notification_channels

    alert_strategy {
        auto_close = "3600s" # 1 hour
    }

    # severity = "WARNING"      # Uncomment when using provider version > 5.11.0

    combiner = "OR"

    conditions {

        condition_threshold {

            aggregations {
                alignment_period     = "60s"
                cross_series_reducer = "REDUCE_SUM"
                per_series_aligner   = "ALIGN_SUM"
            }

            comparison = "COMPARISON_GT"
            duration   = "60s"
            filter     = "resource.type = \"logging_bucket\" AND metric.type = \"logging.googleapis.com/user/${var.monitored_gcp_project}-secret-creation-outside-primary-region\""

            trigger {
                count = 1
            }

        }

        display_name = "Secret Created outside primary region in ${var.monitored_gcp_project}"
    }

    documentation {
        content   = "Secret Created outside primary region in ${var.monitored_gcp_project}.\n\nPlease check logs in the ${var.project_id} project:\n\n${var.link_to_logs}"
        mime_type = "text/markdown"
    }

    depends_on = [
        google_logging_metric.secret_creation_regions_non_prod,
        null_resource.delay
    ]

}

##############################################################################
### Create Custom Logging Metric for Created, Deleted & Updated IAM Roles ####
##############################################################################

resource "google_logging_metric" "iam_role_creation_deletion_update" {
    
    name            = "${var.monitored_gcp_project}-iam-role-created-or-deleted-or-updated"
    filter          = "protoPayload.methodName=\"google.iam.admin.v1.CreateRole\" OR protoPayload.methodName=\"google.iam.admin.v1.DeleteRole\" OR protoPayload.methodName=\"google.iam.admin.v1.UpdateRole\""

    project         = var.project_id

    bucket_name     = var.logging_bucket_name

    metric_descriptor {

        unit            = "1"
        value_type      = "INT64"
        metric_kind     = "DELTA"
        display_name    = "${var.monitored_gcp_project} IAM Role Created, Deleted or Updated."
    }

}

##########################################################
### Create Alert Policy to Detect IAM Roles Changes ######
##########################################################


resource "google_monitoring_alert_policy" "monitor_iam_roles" {

    display_name            = "Changes occured for IAM roles in ${var.monitored_gcp_project}"

    project                 = var.project_id

    enabled                 = true

    notification_channels   = var.alert_notification_channels

    alert_strategy {
        auto_close = "3600s" # 1 hour
    }

    # severity = "CRITICAL"     # Uncomment when using provider version > 5.11.0

    combiner = "OR"

    conditions {

        condition_threshold {

            aggregations {
                alignment_period     = "60s"
                cross_series_reducer = "REDUCE_SUM"
                per_series_aligner   = "ALIGN_SUM"
            }

            comparison = "COMPARISON_GT"
            duration   = "60s"
            filter     = "resource.type = \"logging_bucket\" AND metric.type = \"logging.googleapis.com/user/${var.monitored_gcp_project}-iam-role-created-or-deleted-or-updated\""

            trigger {
                count = 1
            }

        }

        display_name = "IAM role created or deleted or updated in ${var.monitored_gcp_project}"
    }

    documentation {
        content   = "IAM role created or deleted or updated in ${var.monitored_gcp_project}.\n\nPlease check logs in the ${var.project_id} project:\n\n${var.link_to_logs}"
        mime_type = "text/markdown"
    }

    depends_on = [
        google_logging_metric.iam_role_creation_deletion_update,
        null_resource.delay
    ]

}

############################################################
### Create Custom Logging Metric for IAM Policy Changes ####
############################################################

resource "google_logging_metric" "changed_iam_policy" {
    
    name            = "${var.monitored_gcp_project}-iam-policy-changed"
    filter          = "protoPayload.serviceName=\"cloudresourcemanager.googleapis.com\" AND protoPayload.methodName=\"SetIamPolicy\""

    project         = var.project_id

    bucket_name     = var.logging_bucket_name

    metric_descriptor {

        unit            = "1"
        value_type      = "INT64"
        metric_kind     = "DELTA"
        display_name    = "${var.monitored_gcp_project} IAM Policy Changed"
    }

}

##########################################################
### Create Alert Policy to Detect IAM Policy Changes #####
##########################################################


resource "google_monitoring_alert_policy" "monitor_iam_policy_changes" {

    display_name            = "Changes occured for the IAM Policy in ${var.monitored_gcp_project}"

    project                 = var.project_id

    enabled                 = true

    notification_channels   = var.alert_notification_channels

    alert_strategy {
        auto_close = "3600s" # 1 hour
    }

    # severity = "CRITICAL"     # Uncomment when using provider version > 5.11.0

    combiner = "OR"

    conditions {

        condition_threshold {

            aggregations {
                alignment_period     = "60s"
                per_series_aligner   = "ALIGN_DELTA"
                cross_series_reducer = "REDUCE_NONE"
            }

            comparison = "COMPARISON_GT"
            duration   = "0s"
            filter     = "resource.type = \"logging_bucket\" AND metric.type = \"logging.googleapis.com/user/${var.monitored_gcp_project}-iam-policy-changed\""

            trigger {
                count = 1
            }

        }

        display_name = "IAM Policy changed in ${var.monitored_gcp_project}"
    }

    documentation {
        content   = "IAM Policy changed in ${var.monitored_gcp_project}.\n\nPlease check logs in the ${var.project_id} project:\n\n${var.link_to_logs}"
        mime_type = "text/markdown"
    }

    depends_on = [
        google_logging_metric.changed_iam_policy,
        null_resource.delay
    ]

}

