locals {
    notification_channels = {
        for items in var.notification_channels_config:
            items.alert_receiver => items
   
    }
}



########################################################
### Notification Channel for Alerting via E-Mail  ######
########################################################

resource "google_monitoring_notification_channel" "alert_channel" {

    for_each        = local.notification_channels
    
    display_name    = "${each.value.alert_receiver} email address"
    description     = "Notification Channel for sending alerts via ${each.value.channel_type} to ${each.value.alert_receiver}"
    type            = "${each.value.channel_type}"

    project         = var.project_id

    enabled         = true

    labels = {
        email_address    = "${each.value.email_address}"
    }
}