###########################################
### Create HTTPS Uptime Check Config  #####
###########################################


resource "google_monitoring_uptime_check_config" "uptime_check" {

    display_name = "${var.uptime_check_display_name} uptime check."

    # Maximum time to wait for the request to complete (in seconds)
    timeout = var.uptime_check_request_wait_time

    # How often the uptime check is performed
    period = var.uptime_check_frequency

    selected_regions = var.selected_regions

    dynamic "content_matchers" {
        for_each = var.content_matchers

        content {
            content = content_matchers.value.content
            matcher = content_matchers.value.matcher
        }

    }


    project = var.project_id

    http_check {
        request_method = "GET"
        mask_headers = var.mask_headers
        path = var.http_check_path
        port = 443
        use_ssl = true
        validate_ssl = true

        dynamic "accepted_response_status_codes" {
            for_each = var.accepted_response_status_codes
            content {
                status_class = lookup(accepted_response_status_codes.value, "status_class", null)
                status_value = lookup(accepted_response_status_codes.value, "status_value", null)
            }
        }


    }

    monitored_resource {
        type = "uptime_url"
        labels = {
            host = var.uptime_url
            project_id = var.project_id
        }
    }


}

################################################
### Create Uptime Check Monitoring Alert   #####
################################################
 

resource "google_monitoring_alert_policy" "uptime_check_alert" {


    display_name            = "${var.uptime_check_display_name} uptime check alert"

    project                 = var.project_id

    enabled                 = true

    notification_channels   = var.alert_notification_channels

    alert_strategy {
        # If an alert policy that was active has no data for this long,
        # any open incidents will close
        auto_close = var.alert_auto_close # Corresponds to 1 day
    }

    combiner = "OR"

    conditions {

        condition_threshold {

            aggregations {
                alignment_period     = "1200s"
                cross_series_reducer = "REDUCE_COUNT_FALSE"
                group_by_fields = [
                    "resource.label.*"
                ]
                per_series_aligner   = "ALIGN_NEXT_OLDER"
            }

            comparison      = "COMPARISON_GT"
            threshold_value = "1"
            duration        = "60s"
            filter          = "metric.type=\"monitoring.googleapis.com/uptime_check/check_passed\" AND metric.label.check_id=\"${google_monitoring_uptime_check_config.uptime_check.uptime_check_id}\" AND resource.type=\"uptime_url\""
            trigger {
                count = var.trigger_count
            }
        
        }

        display_name = "${var.uptime_check_display_name} UpTime Check Failed."

    }

    documentation {
        content   = "${var.uptime_check_display_name} UpTime Check Failed.\n\nCheck the availability of the service."
        mime_type = "text/markdown"
    }

    depends_on = [
        google_monitoring_uptime_check_config.uptime_check
    ]


}