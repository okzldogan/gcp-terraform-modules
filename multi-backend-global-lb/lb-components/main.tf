locals {
    
    domains = flatten([
        for domain in var.managed_ssl_certificate_config : [
            for subdomain in domain.domains : "${subdomain}"
        ]
    ])
}

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

}

########################################################
##### Make DNS 'A' Entry for the Static IP Address #####
########################################################


# resource "google_dns_record_set" "dns_entry" {

#     for_each       = toset(local.domains)

#     project       = "southpole-dns"

#     # Split the list of strings into strings
#     managed_zone  = "${split(".", each.value)[1]}.${split(".", each.value)[2]}"

#     # Use the part of the domain name after the first dot as domain and the part before the first dot as subdomain
#     name          = "${split(".", each.value)[0]}.${split(".", each.value)[1]}.${split(".", each.value)[2]}."

#     type          = "A"
#     ttl           = "60"

#     rrdatas       = [
#         google_compute_global_address.public_ip_address.address
#     ]
# }

############################################
##### Generate Managed SSL Certificate #####
############################################

resource "google_compute_managed_ssl_certificate" "cert" {

    count       = length(var.managed_ssl_certificate_config)
    
    name        = "${var.resource_name}-managed-ssl-certificate"
    project     = var.project_id
    description = "Managed SSL Certificate for ${var.resource_name} External Global LB."
    type        = "MANAGED"

    lifecycle {
        create_before_destroy = true
    }

    managed {
        domains = var.managed_ssl_certificate_config[count.index].domains
    }

    depends_on = [
        google_compute_global_address.public_ip_address,
        # google_dns_record_set.dns_entry
    ]

}




#####################################
##### Create Target HTTPS Proxy #####
#####################################

resource "google_compute_target_https_proxy" "elb_https_proxy" {

    provider            = google-beta
    
    name                = "multi-backend-lb-target-https-proxy"
    project             = var.project_id
    description         = "Target HTTPS Proxy for Multi Backend External Global LB."
    url_map             = var.url_map_id

    ssl_policy          = var.ssl_policy_name

    ssl_certificates  = google_compute_managed_ssl_certificate.cert == null ? concat(var.self_managed_ssl_certificates, tolist([google_compute_managed_ssl_certificate.cert[0].id])) : var.self_managed_ssl_certificates

}


########################################
##### Create HTTPS Forwarding Rule #####
########################################

resource "google_compute_global_forwarding_rule" "https" {

    provider                = google-beta

    load_balancing_scheme   = "EXTERNAL"

    ip_address              = google_compute_global_address.public_ip_address.id

    name                    = "${var.resource_name}-https-forwarding-rule"
    ip_protocol             = "TCP"
    project                 = var.project_id
    port_range              = "443-443"

    target                  = google_compute_target_https_proxy.elb_https_proxy.id

    depends_on = [
        google_compute_target_https_proxy.elb_https_proxy,
        google_compute_global_address.public_ip_address,
    ]
}

#######################################
##### Create HTTP Forwarding Rule #####
#######################################

# resource "google_compute_global_forwarding_rule" "http" {

#     provider                = google-beta

#     count                   = var.launch_http_forwarding_rule ? 1 : 0

#     load_balancing_scheme   = "EXTERNAL"

#     ip_address              = google_compute_global_address.public_ip_address.id

#     name                    = "${var.resource_name}-http-forwarding-rule"
#     ip_protocol             = "TCP"
#     project                 = var.project_id
#     port_range              = "80-80"

#     target                  = google_compute_target_http_proxy.http_proxy.id

#     depends_on = [
#         google_compute_target_http_proxy.http_proxy,
#         google_compute_global_address.public_ip_address,
#         google_compute_url_map.default_http_proxy,
#     ]
# }

