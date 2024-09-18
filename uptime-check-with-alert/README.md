This module creates an uptime check and an alert policy for the created uptime check.

Example Use of the Module:

```hcl


module "uptime_check_airfix" {
    source          = "../../terraform-modules/uptime-check-with-alert/"

    project_id                      = "${var.prefix}-${var.name}"

    uptime_check_display_name       = "MY-WEBSITE"

    uptime_check_request_wait_time  = "10s"
    uptime_check_frequency          = "60s"

    uptime_url = "www.airfixcarbon.com"


    accepted_response_status_codes = {
        config_class = {
            status_class = "STATUS_CLASS_2XX"
        }
        config_value = {
            status_value = 301
        }
    }

    alert_notification_channels = [
        "my-notification-channel"
    ]


}


```