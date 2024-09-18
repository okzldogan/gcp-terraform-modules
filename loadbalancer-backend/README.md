
######################################
##### Example Use of the Module ######
######################################


module "dcj_staging_loadbalancer_backends" {
    source          = "../../../terraform-modules/loadbalancer-backend/"

    project_id                          = "${var.prefix}-${var.name}"

    backend_config = [
        {
            name                        = "dcj-staging-frontend"
            healthy_threshold           = 1
            unhealthy_threshold         = 2 
            healthcheck_timeout_sec     = 1
            check_interval_sec          = 10
            health_check_port           = 3000
            port_specification          = "USE_FIXED_PORT"
            health_check_path           = "/"
            enable_cdn                  = false
            backend_timeout             = 30
            custom_request_headers = []
            custom_response_headers = [
              "hsts: True",
              "hsts-include-subdomains: True",
              "hsts-max-age: 604800"
            ]
            neg_name        = "dcj-staging-frontend-neg"
            neg_zone_1      = "europe-west1-c"
            neg_zone_2      = "europe-west1-d"
            security_policy = "public-website-policy-staging"
        },
        {
            name                        = "dcj-staging-admin"
            healthy_threshold           = 1
            unhealthy_threshold         = 2 
            healthcheck_timeout_sec     = 1
            check_interval_sec          = 10
            health_check_port           = 3000
            port_specification          = "USE_FIXED_PORT"
            health_check_path           = "/"
            enable_cdn                  = false
            backend_timeout             = 600
            custom_request_headers = []
            custom_response_headers = []
            neg_name        = "dcj-staging-admin-neg"
            neg_zone_1      = "europe-west1-c"
            neg_zone_2      = "europe-west1-d"
            security_policy = "public-website-policy-staging"
        },
        {
            name                        = "dcj-staging-api"
            healthy_threshold           = 1
            unhealthy_threshold         = 2 
            healthcheck_timeout_sec     = 1
            check_interval_sec          = 10
            health_check_port           = 3001
            port_specification          = "USE_FIXED_PORT"
            health_check_path           = "/health"
            enable_cdn                  = false
            backend_timeout             = 28800
            custom_request_headers = []
            custom_response_headers = []
            neg_name        = "dcj-staging-api-neg"
            neg_zone_1      = "europe-west1-c"
            neg_zone_2      = "europe-west1-d"
            security_policy = "public-website-policy-staging"
        },
    ]


}
