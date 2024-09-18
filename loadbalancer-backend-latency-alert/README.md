This module creates an alert policy for monitoring the loadbalancer backend latency.

Example Use of the Module 

```hcl

module "load_balancer_backend_latency_monitoring" {
    source          = "../terraform-modules/loadbalancer-backend-latency-alert/"

    project_id                  = "my-project"


    application_name            = "My Application"

    alert_notification_channels = [
        "projects/my-project/notificationChannels/my-channel-id",
    ]

    backend_latency_threshold   = "2000" # 2 seconds

    backend_name                = "my-backend-name"

    link_to_dashboards          = "link-to-gcp-managed-loadbalancer-dashboard"


}

```
