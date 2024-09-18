This module creates zonal backend services for a load balancer. It refers to a Kubernetes Network Endpoint Group (NEG) for the backend service.

######################################
##### Example Use of the Module ######
######################################


module "loadbalancer_zonal_backends" {
    source          = "../terraform-modules/loadbalancer-zonal-backend/"

    project_id                          = "my-project"

    backend_config = [
        {
            name                        = "my-backend-service"
            healthy_threshold           = 1
            unhealthy_threshold         = 2 
            healthcheck_timeout_sec     = 15
            check_interval_sec          = 15
            health_check_port           = 80
            port_specification          = "USE_FIXED_PORT"
            health_check_path           = "/my-healthcheck-path"
            enable_cdn                  = false     # Set to true to enable CDN
            backend_timeout             = 300
            custom_request_headers = []             # Add custom request headers
            custom_response_headers = [
              "hsts: True",
              "hsts-include-subdomains: True",
              "hsts-max-age: 31536000"    # 1 year
            ]
            neg_name        = "my-kubernetes-neg-service"
            neg_zone_1      = "my-zone"
            security_policy = "my-cloud-armor-security-policy"
        },
        {
            name                        = "my-backend-service-2"
            healthy_threshold           = 1
            unhealthy_threshold         = 2 
            healthcheck_timeout_sec     = 15
            check_interval_sec          = 15
            health_check_port           = 80
            port_specification          = "USE_FIXED_PORT"
            health_check_path           = "/my-healthcheck-path"
            enable_cdn                  = false     # Set to true to enable CDN
            backend_timeout             = 300
            custom_request_headers = []             # Add custom request headers
            custom_response_headers = [
              "hsts: True",
              "hsts-include-subdomains: True",
              "hsts-max-age: 31536000"    # 1 year
            ]
            neg_name        = "my-kubernetes-neg-service-2"
            neg_zone_1      = "my-zone"
            security_policy = "my-cloud-armor-security-policy"
        },

    ]


}