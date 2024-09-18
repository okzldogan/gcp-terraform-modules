locals {
    
    backend_services = { for services in var.backend_services: services["name"] => services }

}



################################
##### Create Health Check  #####
################################


resource "google_compute_health_check" "http_health_check" {
    
    name            = "${var.http_health_check_prefix}-backend-health-check"
    description     = "${var.http_health_check_prefix} health check for the backend service."
    project         = var.project_id

    healthy_threshold   = 1
    unhealthy_threshold = 2

    timeout_sec        = 15
    check_interval_sec = 15

    http_health_check {
        port_specification = "USE_SERVING_PORT"
    }

}


##################################
##### Create Backend Service #####
##################################

resource "google_compute_backend_service" "backend" {

    for_each = local.backend_services
    
    name                    = "${each.key}"
    description             = "${each.key} backend service for the external load balancer."

    enable_cdn              = lookup(each.value, "enable_cdn", false)

    protocol                = "HTTP"
    timeout_sec             = 30

    custom_request_headers  = lookup(each.value, "custom_request_headers", [])
    custom_response_headers = lookup(each.value, "custom_response_headers", [])

    project         = var.project_id

    backend {
        group = "https://www.googleapis.com/compute/v1/projects/sp-gke-dev/zones/europe-west1-c/networkEndpointGroups/${each.key}"
        balancing_mode = "RATE"
        max_rate_per_endpoint = 1.0
        capacity_scaler = 1.0
        
    }

    log_config {
        enable      = true
        sample_rate = 1
    }


    security_policy         = each.value.security_policy


    health_checks           = [
        google_compute_health_check.http_health_check.id
    ]

    depends_on = [
        google_compute_health_check.http_health_check
    ]

}

