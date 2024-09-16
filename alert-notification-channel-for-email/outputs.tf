output "alert_name" {

    value = [
        for alert in google_monitoring_notification_channel.alert_channel: 
        alert.name
    ]
    description = "The created notification channels"
}