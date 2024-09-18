This module creates multiple alerts for restarted pods in the listed namespaces.

Example Use of the Module:

```hcl


module "restared_pods_alerts" {
    source          = "../../../terraform-modules/pod-restart-alert/"

    project_id                  = "my-project"

    notification_channels = [
        "my-notification-channel"        
    ]
    
    pod_restart_monitoring_config = [
        {
            namespace   = "my-namespace"
        },
        {
            namespace   = "another-namespace"
        },
        {
            namespace   = "add-other-namespace"
        },
    ]


}

```