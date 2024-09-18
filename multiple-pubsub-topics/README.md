The present module creates multiple pubsub topics and assign one subscriber to each topic.

Example Use of the Module:

```hcl

module "multiple_pubsubs" {
    
    source          = "../terraform-modules/multiple-pubsub-topics/"

    project_id                          = "my-project"

    labels = {
        app = "my_app"
        environment = "my_environment"
    }

    pubsub_user_service_account = "my-pubsub-user-service-account"

    pubsub_config = {

        my-pubsub-topic-1 = [
            "my-sub-1",
        ]

        my-pubsub-topic-2 = [
            "my-sub-2",
        ]

        my-pubsub-topic-3 = [
            "my-sub-3",
        ]


    }


}

```