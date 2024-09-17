#######################################################
### Alert If Backend Latency Exceeds a Threshold ######
#######################################################


resource "google_monitoring_alert_policy" "backend_latency" {

    display_name            = "High backend latency for ${var.application_name}"

    project                 = var.project_id

    enabled                 = true

    notification_channels   = var.alert_notification_channels

    alert_strategy {
        auto_close = "3600s" # 1 hour
    }

    combiner = "OR"

    conditions {

        condition_threshold {

            aggregations {
                alignment_period     = "60s"
                cross_series_reducer = "REDUCE_MEAN"
                per_series_aligner   = "ALIGN_DELTA"
            }

            comparison = "COMPARISON_GT"
            threshold_value = "${var.backend_latency_threshold}"
            duration   = "300s"

            filter     = "metric.type=\"loadbalancing.googleapis.com/https/backend_latencies\" resource.type=\"https_lb_rule\" resource.label.\"backend_name\"=\"${var.backend_name}\""

            trigger {
                count = 1
            }

        }

        display_name = "Backend Latency > ${var.backend_latency_threshold} milliseconds in ${var.application_name} for at least 5 minutes"
    }

    documentation {
        content   = "Backend Latency exceeds ${var.backend_latency_threshold} milliseconds for ${var.application_name} for at least 5 minutes. \n\nPlease check the performance dashboard and remediate if necessary:\n\n${var.link_to_dashboards}"
        mime_type = "text/markdown"
    }


}
