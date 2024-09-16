###############################################################################
### Create Alert for DCJ-PROD CloudSQL Instance CPU Utilization over 90%  #####
###############################################################################


resource "google_monitoring_alert_policy" "cloudsql_cpu_utilization" {

    display_name            = "${var.cloudsql_project_reference} CloudSQL Instance CPU Utilization over 90%."

    project                 = var.project_id

    enabled                 = true

    notification_channels   = var.notification_channels

    alert_strategy {
        # If an alert policy that was active has no data for this long,
        # any open incidents will close
        auto_close = var.alert_auto_close
    }

    combiner = "OR"

    conditions {

        condition_threshold {

            aggregations {
                alignment_period     = "120s"
                cross_series_reducer = "REDUCE_MEAN"
                per_series_aligner   = "ALIGN_MEAN"
            }

            comparison      = "COMPARISON_GT"
            threshold_value = "0.9"
            duration        = "300s"
            filter     = "resource.type = \"cloudsql_database\" AND metric.type = \"cloudsql.googleapis.com/database/cpu/utilization\" AND resource.label.database_id=\"${var.cloudsql_db_id}\""

            trigger {
                count = 1
            }

        }

        display_name = "${var.cloudsql_project_reference} CloudSQL Instance over 90% CPU Utilization."

    }

    documentation {
        content   = "${var.cloudsql_project_reference} CloudSQL Instance CPU Utilization over 90%, check the instance.\n\nIf the alert repeats frequently, consider increasing CPU resources."
        mime_type = "text/markdown"
    }


}

###############################################################################
### Create Alert for DCJ-PROD CloudSQL Instance RAM Utilization over 90%  #####
###############################################################################


resource "google_monitoring_alert_policy" "cloudsql_ram_utilization" {

    display_name            = "${var.cloudsql_project_reference} CloudSQL Instance RAM Utilization over 90%"

    project                 = var.project_id

    enabled                 = true

    notification_channels   = var.notification_channels

    alert_strategy {
        # If an alert policy that was active has no data for this long,
        # any open incidents will close
        auto_close = var.alert_auto_close
    }

    combiner = "OR"

    conditions {

        condition_threshold {

            aggregations {
                alignment_period     = "120s"
                cross_series_reducer = "REDUCE_MEAN"
                per_series_aligner   = "ALIGN_MEAN"
            }

            comparison      = "COMPARISON_GT"
            threshold_value = "0.9"
            duration        = "300s"
            filter     = "resource.type = \"cloudsql_database\" AND metric.type = \"cloudsql.googleapis.com/database/memory/utilization\" AND resource.label.database_id=\"${var.cloudsql_db_id}\""

            trigger {
                count = 1
            }

        }
        
        display_name = "${var.cloudsql_project_reference} CloudSQL Instance over 90% CPU Utilization."
        
    }

    documentation {
        content   = "${var.cloudsql_project_reference} CloudSQL Instance RAM Utilization over 90%, check the instance.\n\nIf the alert repeats frequently, consider increasing RAM resources."
        mime_type = "text/markdown"
    }


}


#########################################################################
### Create Alert for DCJ-PROD CloudSQL Instance Active Connections  #####
#########################################################################


resource "google_monitoring_alert_policy" "cloudsql_active_connections" {


    display_name            = "${var.cloudsql_project_reference} CloudSQL Instance Connections reached 80"

    project                 = var.project_id

    enabled                 = true

    notification_channels   = var.notification_channels

    alert_strategy {
        # If an alert policy that was active has no data for this long,
        # any open incidents will close
        auto_close = var.alert_auto_close
    }

    combiner = "OR"

    conditions {

        condition_threshold {

            aggregations {
                alignment_period     = "60s"
                cross_series_reducer = "REDUCE_SUM"
                per_series_aligner   = "ALIGN_MAX"
            }

            comparison      = "COMPARISON_GT"
            threshold_value = "${var.active_connections_threshold}"
            duration        = "300s"
            filter     = "resource.type = \"cloudsql_database\" AND metric.type = \"cloudsql.googleapis.com/database/postgresql/num_backends\" AND resource.label.database_id=\"${var.cloudsql_db_id}\""

            trigger {
                count = 1
            }
        
        }

        display_name = "${var.cloudsql_project_reference} CloudSQL Instance Active Connections reached 80% capacity."

    }

    documentation {
        content   = "${var.cloudsql_project_reference} CloudSQL Instance Active Connections reached ${var.active_connections_threshold}, max connections allowed is ${var.max_active_connections}.\n\nIf the alert repeats frequently, consider increasing max connections."
        mime_type = "text/markdown"
    }


}
