###################################
##### Reserve Static IP Proxy #####
###################################


resource "google_compute_global_address" "lb_public_ip_addres" {
    
    provider        = google-beta

    name            = "${var.loadbalancer_name}-static-ip"
    description     = "Global IP for ${var.loadbalancer_name}"
    address_type    = "EXTERNAL"
    ip_version      = "IPV4"
    project         = var.project_id

}


#####################################
##### Create Target HTTPS Proxy #####
#####################################

resource "google_compute_target_https_proxy" "lb_https_proxy" {

    provider            = google-beta
    
    name                = "${var.loadbalancer_name}-target-https-proxy"
    project             = var.project_id
    description         = "Target HTTPS Proxy for ${var.loadbalancer_name} External Global LB."
    url_map             = var.url_map_id

    ssl_policy          = var.ssl_policy_name

    ssl_certificates    = var.ssl_certificates


}


########################################
##### Create HTTPS Forwarding Rule #####
########################################

resource "google_compute_global_forwarding_rule" "https_forwarding_rule" {

    provider                = google-beta

    load_balancing_scheme   = "EXTERNAL"

    ip_address              = google_compute_global_address.lb_public_ip_addres.id

    name                    = "${var.loadbalancer_name}-https-forwarding-rule"
    ip_protocol             = "TCP"
    project                 = var.project_id
    port_range              = "443-443"

    target                  = google_compute_target_https_proxy.lb_https_proxy.id

    depends_on = [
        google_compute_target_https_proxy.lb_https_proxy,
        google_compute_global_address.lb_public_ip_addres
    ]
}