The present module creates multiple subscribers and creates the pubsub topic.

Example Use of the Module:

```hcl

module "multiple_topic_subscription_" {
    
    source          = "../terraform-modules/pubsub-multiple-subscriber/"

    project_id                          = "my-project"

    labels = {
        app = "climate_ready"
        environment = "staging"
    }

    topic_name = "my-pubsub-topic"

    pubsub_user_service_account = "my-pubsub-service-account"

    subscription_config = [
        {
            subscriber_name      = "my-sub-1"
        },
        {
            subscriber_name      = "my-sub-2"
        },
    ]


}

```