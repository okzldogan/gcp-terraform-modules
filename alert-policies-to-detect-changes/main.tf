############################################################################
### Create Custom Logging Metric for Monitoring Login Failures in MySQL ####
############################################################################

resource "google_logging_metric" "mysql_login_failures" {

    count           = var.db_engine == "mysql" ? 1 : 0
    
    name            = "${var.monitored_gcp_project}-mysql-login-failures"
    filter          = "textPayload=~\"Access denied\" NOT textPayload=~\"Account is blocked\""

    project         = var.project_id

    bucket_name     = var.logging_bucket_name

    metric_descriptor {

        unit            = "1"
        value_type      = "INT64"
        metric_kind     = "DELTA"
        display_name    = "${var.monitored_gcp_project} Login Failure in MySQL"
    }

}

###########################################################################
### Create Custom Logging Metric for Monitoring Blocked Users in MySQL ####
###########################################################################

resource "google_logging_metric" "mysql_blocked_user" {

    count           = var.db_engine == "mysql" ? 1 : 0
    
    name            = "${var.monitored_gcp_project}-mysql-blocked-user"
    filter          = "textPayload=~\"Account is blocked\""

    project         = var.project_id

    bucket_name     = var.logging_bucket_name

    metric_descriptor {

        unit            = "1"
        value_type      = "INT64"
        metric_kind     = "DELTA"
        display_name    = "A MySQL User Account Blocked in db instance ${var.monitored_gcp_project}"
    }

}

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

######################################################################################
### Create Custom Logging Metric for Cloud SQL Instance' Users Created or Deleted ####
######################################################################################

resource "google_logging_metric" "cloudsql_instance_sql_user_modifications" {
    
    name            = "${var.monitored_gcp_project}-cloudsql-db-user-modified"
    filter          = "protoPayload.methodName=\"cloudsql.users.create\" OR protoPayload.methodName=\"cloudsql.users.delete\" AND NOT protoPayload.authenticationInfo.principalEmail=\"terraform-host@terraform-bastion.iam.gserviceaccount.com\""

    project         = var.project_id

    bucket_name     = var.logging_bucket_name

    metric_descriptor {

        unit            = "1"
        value_type      = "INT64"
        metric_kind     = "DELTA"
        display_name    = "${var.monitored_gcp_project} Cloud SQL DB User modified"
    }

}
####################################################################################
### Create Custom Logging Metric for Cloud SQL Instance' Users Password Changed ####
####################################################################################

resource "google_logging_metric" "cloudsql_instance_sql_user_password_change" {
    
    name            = "${var.monitored_gcp_project}-cloudsql-db-user-password-changed"
    filter          = "protoPayload.methodName=\"cloudsql.users.update\" AND NOT protoPayload.authenticationInfo.principalEmail=\"o.kizildogan@southpole.com\""

    project         = var.project_id

    bucket_name     = var.logging_bucket_name

    metric_descriptor {

        unit            = "1"
        value_type      = "INT64"
        metric_kind     = "DELTA"
        display_name    = "${var.monitored_gcp_project} Cloud SQL DB User password changed"
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

##############################################################################################
### Create Alert Policy for Cloud SQL DB Instance User Modifications Outside Terraform #######
##############################################################################################


resource "google_monitoring_alert_policy" "monitor_cloudsql_user_modifications" {

    display_name            = "Cloud SQL User created or deleted for Cloud SQL instance in ${var.monitored_gcp_project}"

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
            filter     = "resource.type = \"logging_bucket\" AND metric.type = \"logging.googleapis.com/user/${var.monitored_gcp_project}-cloudsql-db-user-modified\""

            trigger {
                count = 1
            }

        }

        display_name = "Cloud SQL User created or deleted outside Terraform IaC in ${var.monitored_gcp_project}"
    }

    documentation {
        content   = "Cloud SQL User created or deleted outside Terraform IaC in ${var.monitored_gcp_project}.\n\nPlease check logs in the ${var.project_id} project:\n\n${var.link_to_logs}"
        mime_type = "text/markdown"
    }

    depends_on = [
        google_logging_metric.cloudsql_instance_sql_user_modifications,
        null_resource.delay
    ]

}

###############################################################################
### Create Alert Policy for Cloud SQL DB Instance User Password Change  #######
###############################################################################


resource "google_monitoring_alert_policy" "monitor_cloudsql_user_password_change" {

    display_name            = "Cloud SQL User password changed for Cloud SQL instance in ${var.monitored_gcp_project}"

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
            filter     = "resource.type = \"logging_bucket\" AND metric.type = \"logging.googleapis.com/user/${var.monitored_gcp_project}-cloudsql-db-user-password-changed\""

            trigger {
                count = 1
            }

        }

        display_name = "Cloud SQL User password changed by non-Cloud Admin User"
    }

    documentation {
        content   = "Cloud SQL User password changed by non-Cloud Admin User in ${var.monitored_gcp_project}.\n\nPlease check logs in the ${var.project_id} project:\n\n${var.link_to_logs}"
        mime_type = "text/markdown"
    }

    depends_on = [
        google_logging_metric.cloudsql_instance_sql_user_password_change,
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

##################################################################
### Create Alert Policy for Too Many MySQL Login Failures  #######
##################################################################


resource "google_monitoring_alert_policy" "mysql_too_many_login_failures" {

    count                   = var.db_engine == "mysql" ? 1 : 0

    display_name            = "Too Many MySQL Login Failures in ${var.monitored_gcp_project} db instance."

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
                alignment_period     = "900s"           # Checks last 15 minutes
                cross_series_reducer = "REDUCE_SUM"
                per_series_aligner   = "ALIGN_SUM"
            }

            comparison = "COMPARISON_GT"
            threshold_value = "4"
            duration   = "60s"
            filter     = "resource.type = \"logging_bucket\" AND metric.type = \"logging.googleapis.com/user/${var.monitored_gcp_project}-mysql-login-failures\""

            trigger {
                count = 1
            }

        }

        display_name = "5 MySQL Login failures detected in the last 15 minutes in ${var.monitored_gcp_project} db instance"
    }

    documentation {
        content   = "5 MySQL Login failures detected in ${var.monitored_gcp_project} db instance in the last 15 minutes.\n\nPlease check logs in the ${var.project_id} project:\n\n${var.link_to_logs}"
        mime_type = "text/markdown"
    }

    depends_on = [
        google_logging_metric.mysql_login_failures,
        null_resource.delay
    ]

}

#######################################################
### Create Alert Policy for Blocked MySQL User  #######
#######################################################


resource "google_monitoring_alert_policy" "blocked_mysql_user" {

    count                   = var.db_engine == "mysql" ? 1 : 0

    display_name            = "Blocked MySQL User in ${var.monitored_gcp_project} db instance for too many failed login attempts."

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
            filter     = "resource.type = \"logging_bucket\" AND metric.type = \"logging.googleapis.com/user/${var.monitored_gcp_project}-mysql-blocked-user\""

            trigger {
                count = 1
            }

        }

        display_name = "A MySQL user blocked in ${var.monitored_gcp_project} db instance for too many failed login attempts"
    }

    documentation {
        content   = "A MySQL user blocked in ${var.monitored_gcp_project} db instance for too many failed login attempts.\n\nPlease check logs in the ${var.project_id} project:\n\n${var.link_to_logs}"
        mime_type = "text/markdown"
    }

    depends_on = [
        google_logging_metric.mysql_login_failures,
        null_resource.delay
    ]

}
