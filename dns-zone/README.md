This module creates a dns-zone.

There are 5 types of private DNS zones which are the following:

# Peering ( Peer with another network)
# Forwarding ( Target Name Servers Required)
# Private ( Standard)
# Reverse Lookup
# Service Directory ( Service Namespace URL Required)

The module can also create Public DNS zones.

Choose the type from the below: 
peering, forwarding, private, public, reverse_lookup or service_directory

 ######################################
 ##### Example Use of the Module ######
 ######################################

module "private_dns_zone" {
    source          = "../../../terraform-modules/dns-zone/"

    type                            = "private"

    project_id                      = "<project-id>"
    zone_name                       = "<zone-name>"

    domain_name                     = "example.local."      # "Final character with a dot"

    zone_description                = "Private DNS Zone for DEV Environment"

    enable_cloud_logging            = false     # Available only for Public Zones

    enable_gke_clusters             = false     # Even false GKE accesses the DNS registry.

    force_destroy                   = false

    labels                          = {
        env     = "dev"
        cluster = "sp_gke_dev"
        domain  = "sp_gke_dev_local"
    }

    private_visibility_config_networks = [
        "projects/<project-name>/global/networks/<vpc-name>"
    ]

        
}