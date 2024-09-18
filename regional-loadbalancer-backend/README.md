This module creates regional backends to be used for load balancers making reference to NEGs provisioned in GKE.

# Example Use of the Module 

```hcl

module "regional_loadbalancer_backends" {
    source          = "../terraform-modules/regional-loadbalancer-backend/"

    project_id                          = "my-project"

    backend_config = [
        {
            name                        = "my-app-frontend"
            healthy_threshold           = 1
            unhealthy_threshold         = 2 
            healthcheck_timeout_sec     = 1
            check_interval_sec          = 10
            health_check_port           = my-port-number
            port_specification          = "USE_FIXED_PORT"
            health_check_path           = "/my-healthcheck-path"
            enable_cdn                  = false
            backend_timeout             = 30
            custom_request_headers = []
            custom_response_headers = [
              "add-header",
              "add-another-header",
            ]
            neg_name        = "my-neg-name"
            neg_zone_1      = "my-zone-1"
            neg_zone_2      = "my-zone-2"
            security_policy = "my-security-policy"
        },
        {
            name                        = "my-app-backend"
            healthy_threshold           = 1
            unhealthy_threshold         = 2 
            healthcheck_timeout_sec     = 1
            check_interval_sec          = 10
            health_check_port           = my-port-number
            port_specification          = "USE_FIXED_PORT"
            health_check_path           = "/my-healthcheck-path"
            enable_cdn                  = false
            backend_timeout             = 600
            custom_request_headers = []
            custom_response_headers = []
            neg_name        = "my-other-neg-name"
            neg_zone_1      = "my-zone-1"
            neg_zone_2      = "my-zone-2"
            security_policy = "my-security-policy"
        },

    ]


}

```