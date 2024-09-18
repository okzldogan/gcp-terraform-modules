The present module creates multiple subscribers to a non-existent pubsub topic.

#############
## Example ##
#############

module "multiple_topic_subscription_climateready" {
    
    source          = "../../../terraform-modules/pubsub-multiple-subscriber/"

    project_id                          = "${var.prefix}-${var.name}"

    labels = {
        app = "climate_ready"
        environment = "staging"
    }

    topic_name = "user-upsert"

    pubsub_user_service_account = "${module.gke_spi_climateready_staging_app_sa.gcp_service_account_email}"

    subscription_config = [
        {
            subscriber_name      = "carbonvista-user-upsert-sub"
        },
        {
            subscriber_name      = "carbondata-user-upsert-sub"
        },
    ]



}