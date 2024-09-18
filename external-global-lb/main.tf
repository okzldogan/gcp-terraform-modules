#########################################################
##### Reserve Global IP Address for the External LB #####
#########################################################

resource "google_compute_global_address" "public_ip_address" {
    
    provider        = google-beta

    name            = "${var.resource_name}-static-ip"
    description     = "Global IP for ${var.resource_name}"
    address_type    = "EXTERNAL"
    ip_version      = "IPV4"
    project         = var.project_id

    network         = var.network
}

######################################################################
##### Create Random String for Google Managed SSL Certificate ID #####
######################################################################

resource "random_string" "suffix" {

    count = var.generate_managed_ssl_certificate ? 1 : 0
    
    length  = 4
    upper   = false
    lower   = false
    numeric = true
    special = false
}

############################################
##### Generate Managed SSL Certificate #####
############################################

resource "google_compute_managed_ssl_certificate" "cert" {

    count = try(var.generate_managed_ssl_certificate ? 1 : 0, 0)
    
    name        = "managed-cert-${var.resource_name}-${random_string.suffix.result}"
    project     = var.project_id
    description = "Managed SSL Certificate for ${var.resource_name} External Global LB."
    type        = "MANAGED"

    lifecycle {
        create_before_destroy = true
    }

    managed {
        domains = var.managed_domains
    }

}

################################
##### Create Health Check  #####
################################


resource "google_compute_health_check" "http_health_check" {
    
    name            = "${var.resource_name}-backend-health-check"
    description     = "${var.resource_name} health check for the backend service"
    project         = var.project_id

    healthy_threshold   = 1
    unhealthy_threshold = 2

    timeout_sec        = 15
    check_interval_sec = 15


    http_health_check {
        port = 80
        request_path = var.http_health_check_path
    }

}

######################################################
##### Create Network Endpoint Group for Backend  #####
######################################################


resource "google_compute_network_endpoint_group" "neg" {
    
    name                  = "${var.resource_name}-neg"
    network               = var.network
    subnetwork            = var.neg_subnet
    project               = var.project_id
    default_port          = var.neg_default_port
    zone                  = var.neg_zone
    network_endpoint_type = "GCE_VM_IP_PORT"
}

##################################
##### Create Backend Service #####
##################################


resource "google_compute_backend_service" "default" {
    
    name                    = "${var.resource_name}-backend-service"
    port_name               = "${var.resource_name}-backend-port"
    project                 = var.project_id
    session_affinity        = var.session_affinity
    protocol                = "HTTP"
    timeout_sec             = 60

    load_balancing_scheme   = "EXTERNAL"

    log_config {
        enable      = true
        sample_rate = 1
    }

    dynamic "iap" {
        for_each = var.use_iap ? [1] : []

        content {
            oauth2_client_id        = var.oauth2_client_id
            oauth2_client_secret    = var.oauth2_client_secret
        }
    }

    security_policy         = var.security_policy

    health_checks           = [
        google_compute_health_check.http_health_check.id
    ]

    enable_cdn              = var.enable_cdn
    backend {
        group = google_compute_network_endpoint_group.neg.id
        balancing_mode  = "RATE"
        max_rate_per_endpoint = 1.0
        capacity_scaler = 1.0
    }

    depends_on = [
        google_compute_network_endpoint_group.neg
    ]
}

##########################
##### Create URL Map #####
##########################

resource "google_compute_url_map" "elb" {

    provider        = google-beta
    
    name            = "${var.resource_name}-url-map"
    project         = var.project_id
    default_service = google_compute_backend_service.default.id

    dynamic "host_rule" {
        for_each = var.host_rule_config

        content {
            hosts           = toset(each.key)
            path_matcher    = lookup(each.value, "path_matcher", "")
        }
    }

    dynamic "patch_matcher" {
        for_each = var.host_rule_config

        content {
            name            = lookup(each.value, "path_matcher", "")
            default_service = google_compute_backend_service.default.id
        }

        dynamic "path_rule" {
            for_each = var.host_rule_config

            content {
                paths   = lookup(each.value, "paths", "")
                service = google_compute_backend_service.default.id
            }
        }
    }

    # host_rule {
    #     hosts           = var.url_map_hosts
    #     path_matcher    = var.url_map_path_matcher_name
    # }

    # path_matcher {
    #     name            = var.url_map_path_matcher_name
    #     default_service = google_compute_backend_service.default.id
    # }

    depends_on = [
        google_compute_backend_service.default
    ]
}

#####################################
##### Create Target HTTPS Proxy #####
#####################################

resource "google_compute_target_https_proxy" "elb_https_proxy" {
    
    name                = "${var.resource_name}-target-https-proxy"
    provider            = google-beta
    project             = var.project_id
    description         = "Target HTTPS Proxy for ${var.resource_name} External LB."
    url_map             = google_compute_url_map.elb.id
    ssl_policy          = var.ssl_policy_name
    ssl_certificates    = [
        google_compute_managed_ssl_certificate.cert.id
    ]

    depends_on = [
        google_compute_url_map.elb,
        google_compute_managed_ssl_certificate.cert
    ]
}


##################################
##### Create Forwarding Rule #####
##################################

resource "google_compute_global_forwarding_rule" "default" {

    provider                = google-beta

    name                    = "${var.resource_name}-forwarding-rule"
    ip_protocol             = "TCP"
    project                 = var.project_id
    load_balancing_scheme   = "EXTERNAL"
    port_range              = "80"
    target                  = google_compute_target_https_proxy.elb_https_proxy.id
    ip_address              = google_compute_global_address.public_ip_address.id

    depends_on = [
        google_compute_target_https_proxy.elb_https_proxy,
        google_compute_global_address.public_ip_address
    ]
}

