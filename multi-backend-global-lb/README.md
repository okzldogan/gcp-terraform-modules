The "multi-backend-global-lb" folder contains two modules which are "backend-module" and "lb-components".

The "backend-module" defines the NEGs as backends to be used for the Global LB while the "lb-components" module creates the
required remaining components of an external global LB.

It takes approximately a minute to deploy the global LB and another 2-3 minutes for the URL map to route the requests consistently to
the backends.


###############################
###  Example Deployment #######
###############################



#########################################
###  Global LB with Multiple NEGs #######
#########################################


module "lb_backends" {

    source          = "../../../terraform-modules/multi-backend-global-lb/backend-module"


    project_id          = "${var.prefix}-${var.name}"
    http_health_check_prefix      = "multi-lb-test"

    backend_services    = [

        {
            name = "loadbalancer-test-neg"
            enable_cdn              = false
            security_policy         = "public-website-policy-dev"
            
        },
        {
            name = "test-ns-lb-neg"
            enable_cdn              = false
            security_policy         = "public-website-policy-dev"
            
        },

    ]
    

}


###########################
##### Create URL Map  #####
###########################

resource "google_compute_url_map" "default" {
    
    provider        = google-beta

    name            = "multi-backend-lb-url-map"
    project         = "${var.prefix}-${var.name}"
    description     = "Multi Backend LB URL map."

    default_service = module.lb_backends.backend_ids[0]  

    
    host_rule {
        hosts        = ["loadbalancer-test.southpole.cloud"]
        path_matcher = "loadbalancer-test"
    }

    path_matcher {
        name = "loadbalancer-test"
        default_service = module.lb_backends.backend_ids[0]

        path_rule {
            paths = ["/"]
            service = module.lb_backends.backend_ids[0]
        }
    }

    host_rule {
        hosts        = ["test-ns-lb.southpole.cloud"]
        path_matcher = "test-ns-lb"
    }

    path_matcher {
        name = "test-ns-lb"
        default_service = module.lb_backends.backend_ids[1]

        path_rule {
            paths = ["/"]
            service = module.lb_backends.backend_ids[1]
        }
    }

    depends_on = [
        module.lb_backends
    ]


}

module "lb_components" {

    source          = "../../../terraform-modules/multi-backend-global-lb/lb-components"


    project_id          = "${var.prefix}-${var.name}"
    resource_name       = "multi-lb-test"
    ssl_policy_name     = "ssl-policy-tls-12-restricted"

    url_map_id          = google_compute_url_map.default.id

    # launch_http_forwarding_rule = false

    self_managed_ssl_certificates       = [
        "loadbalancer-test-southpole-cloud-cert",
        "test-ns-lb-southpole-cloud-cert"
    ]

    depends_on = [
        google_compute_url_map.default
    ]

}


