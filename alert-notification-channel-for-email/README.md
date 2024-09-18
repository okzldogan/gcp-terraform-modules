This module creates multiple notification channels with the "email" type.

Example Use of the Module:

```hcl

module "gke_email_alert_channels" {
    source          = "../../../terraform-modules/alert-notification-channel-for-email/"

    project_id                          = "my-project"

    notification_channels_config = [
        {
            alert_receiver          = "John Doe"
            email_address           = "john-doe@my-domain.com"
            channel_type            = "email"   
        },
        {
            alert_receiver          = "My Team"
            email_address           = "my-team@my-domain.com"
            channel_type            = "email"   
        },
    ]


}
```