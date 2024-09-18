locals {
    alerts = {
        for items in var.alerts_config:
            items.name => items
   
    }
}

##########################################
### Custom Filter for Alert Policy  ######
##########################################


resource "google_logging_metric" "custom_metric" {

    for_each        = local.alerts
    
    name            = "${each.value.custom_metric_name}"
    filter          = "${each.value.filter}"

    project         = var.project_id

    bucket_name     = "${each.value.bucket_name}"

    metric_descriptor {

        unit            = "1"
        value_type      = "INT64"
        metric_kind     = "DELTA"
        display_name    = "${each.value.custom_metric_name}"
    }

}


########################
### Alert Policy  ######
########################


resource "google_monitoring_alert_policy" "alert" {

    for_each                = local.alerts

    display_name            = "${each.value.name}"

    project                 = var.project_id

    enabled                 = true

    notification_channels   = var.notification_channels

    alert_strategy {
        auto_close = "${each.value.auto_close}"

    }

    combiner = "OR"

    conditions {

        condition_threshold {

            aggregations {
                alignment_period     = "${each.value.alignment_period}"
                cross_series_reducer = "REDUCE_SUM"
                per_series_aligner   = "ALIGN_SUM"
            }

            comparison = "COMPARISON_GT"
            duration   = "${each.value.condition_threshold_duration}"
            filter     = "resource.type = \"logging_bucket\" AND metric.type = \"logging.googleapis.com/user/${each.value.custom_metric_name}\""

            trigger {
                count = 1
            }

        }

        display_name = "${each.value.name}"
    }

    documentation {
        content   = "${each.value.name}. \n\n ${each.value.content_message}"
        mime_type = "text/markdown"
    }

    depends_on = [
        google_logging_metric.custom_metric
    ]


}
