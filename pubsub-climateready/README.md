The present module creates multiple pubsub topics and assign one subscriber to each topic.

#############
## Example ##
#############

module "multiple_pubsubs_climateready" {
    
    source          = "../../../terraform-modules/pubsub-climateready/"

    project_id                          = "${var.prefix}-${var.name}"

    labels = {
        app = "climate_ready"
        environment = "staging"
    }

    pubsub_user_service_account = "${module.gke_spi_climateready_staging_app_sa.gcp_service_account_email}"

    pubsub_config = {

        user-registration = [
            "carbonvista-user-registration-sub",
        ]

        user-delete = [
            "carbonvista-user-delete-sub",
        ]
        
        survey-type-edit = [
            "climate-ready-survey-type-edit-sub",
        ]

        survey-delete = [
            "carbondata-survey-delete-edit-sub",
        ]

        company-upsert-req = [
            "company-upsert-req",
        ]

        company-upsert-res = [
            "climate-ready-company-upsert-res-sub"
        ]

        company-reset = [
            "carbonvista-company-reset-sub"
        ]

        company-location-upsert-req = [
            "carbonvista-company-location-upsert-req-sub"
        ]

        company-location-upsert-res = [
            "climate-ready-company-location-upsert-res-sub"
        ]

        company-location-delete = [
            "carbonvista-company-location-delete-sub"
        ]


    }


}