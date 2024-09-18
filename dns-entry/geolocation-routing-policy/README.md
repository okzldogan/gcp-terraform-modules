This module creates a geolocation routing policy dns entry.

 ######################################
 ##### Example Use of the Module ######
 ######################################

 module "weighted_routing_policy_dns_entry" {
    source          = "../../../terraform-modules/dns-entry/geolocation-routing-policy/"                        

    project_id                  = "<project-id>"
    zone_name                   = "<zone-name>"

    domain_name                 = "example.local."      # "Final character with a dot"

    dns_entry_name              = "test-entry"
    TTL                         = 300
    dns_record_type             = "A"

    geolocation_routing_config = [
        {
            location  = "europe-west1"
            rrdatas   = ["10.128.1.1"]
        },
        {
            location  = "europe-north1"
            rrdatas   = ["10.138.1.1"]
        }
    ]

        
}