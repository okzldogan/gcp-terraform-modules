locals {
    pod_restart_monitoring = {
        for items in var.pod_restart_monitoring_config:
            items.namespace => items
   
    }
}

resource "google_monitoring_alert_policy" "pod_restart_alert" {

    for_each                = local.pod_restart_monitoring

    display_name            = "A pod restarted in the ${each.value.namespace} namespace"

    project                 = var.project_id

    enabled                 = true

    notification_channels   = var.notification_channels

    alert_strategy {
        # 2 hours
        auto_close = "7200s"

        notification_channel_strategy {
            renotify_interval = "1800s" # 30 minutes
        }
    }

    combiner = "OR"

    conditions {

        condition_threshold {

            aggregations {
                alignment_period     = "120s"
                per_series_aligner   = "ALIGN_DELTA"
                cross_series_reducer = "REDUCE_NONE"
            }

            comparison = "COMPARISON_GT"
            duration   = "60s"
            filter     = "metric.type=\"kubernetes.io/container/restart_count\" resource.type=\"k8s_container\" resource.label.\"namespace_name\"=\"${each.value.namespace}\""

            trigger {
                count = 1
            }

        }

        display_name = "A pod restarted in ${each.value.namespace} namespace in ${var.project_id}"
    }

    documentation {
        content   = "A pod restarted in ${each.value.namespace} namespace in ${var.project_id}. \n\nCheck the ${each.value.namespace} namespace."
        mime_type = "text/markdown"
    }


}