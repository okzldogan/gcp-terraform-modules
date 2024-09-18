This module creates a weighted routing policy dns entry.

 ######################################
 ##### Example Use of the Module ######
 ######################################



module "weighted_routing_policy_dns_entry" {
    source          = "../../../terraform-modules/dns-entry/weighted-routing-policy/"                    

    project_id                  = "<project-id>"
    zone_name                   = "<zone-name>"
    domain_name                 = "example.local."

    dns_entry_name              = "test"
    TTL                         = 300
    dns_record_type             = "A"

    weighted_routing_config = [
        {
            weight  = 0.7
            rrdatas = ["10.128.1.1"]
        },
        {
            weight  = 0.3
            rrdatas = ["10.138.1.1"]
        }
    ]

        
}