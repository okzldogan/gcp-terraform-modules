locals {
    
    backend_services = {
        for items in var.backend_config:
            items.name => items
    }

}



################################
##### Create Health Check  #####
################################


resource "google_compute_health_check" "http_health_check" {

    for_each        = local.backend_services
    
    name            = "${each.value.name}-backend-health-check"
    description     = "Health check for the ${each.value.name} backend service."
    project         = var.project_id

    healthy_threshold   = lookup(each.value, "healthy_threshold", 1)
    unhealthy_threshold = lookup(each.value, "unhealthy_threshold", 2)

    timeout_sec        = lookup(each.value, "healthcheck_timeout_sec", 15) 
    check_interval_sec = lookup(each.value, "check_interval_sec", 10)

    http_health_check {
        port_specification = lookup(each.value, "port_specification", "USE_FIXED_PORT")
        port               = lookup(each.value, "health_check_port", 80) 
        request_path       = lookup(each.value, "health_check_path", "/")
    }

}


##################################
##### Create Backend Service #####
##################################

resource "google_compute_backend_service" "backend" {

    for_each                = local.backend_services
    
    name                    = "${each.value.name}"
    description             = "${each.value.name} backend service for the external load balancer."

    load_balancing_scheme   = "EXTERNAL"

    enable_cdn              = lookup(each.value, "enable_cdn", false)

    protocol                = "HTTP"
    timeout_sec             = lookup(each.value, "backend_timeout", 30)

    connection_draining_timeout_sec = lookup(each.value, "connection_draining_timeout_sec", 10)

    custom_request_headers  = lookup(each.value, "custom_request_headers", [])
    custom_response_headers = lookup(each.value, "custom_response_headers", [
        "hsts: True",
        "hsts-include-subdomains: True",
        "hsts-max-age: 31536000"
    ])

    project         = var.project_id

    backend {
        group = "https://www.googleapis.com/compute/v1/projects/${var.project_id}/zones/${each.value.neg_zone_1}/networkEndpointGroups/${each.value.neg_name}"
        balancing_mode = "RATE"
        max_rate_per_endpoint = 1.0
        capacity_scaler = 1.0
        
    }

    log_config {
        enable      = true
        sample_rate = 1.0
    }


    security_policy         = each.value.security_policy


    health_checks           = [
        google_compute_health_check.http_health_check["${each.value.name}"].id
    ]

    depends_on = [
        google_compute_health_check.http_health_check
    ]

}

