This module creates a primary backup routing policy dns entry.

Example Use of the Module:

```hcl

module "primary_backup_routing_policy_dns_entry" {
    source          = "../../../terraform-modules/dns-entry/primary-backup-policy/"                          

    project_id                  = "<project-id>"
    zone_name                   = "<zone-name>"

    domain_name                 = "example.local."      # "Final character with a dot"

    dns_entry_name              = "test"
    TTL                         = 300
    dns_record_type             = "A"

    ILB_IP_ADDRESS              = "my-ip-address"
    ILB_network_url             = "projects/my-vpc-project/global/networks/my-network"
    ILB_project_id              = "my-vpc-project"
    ILB_region                  = "europe-west1"

    primary_backup_trickle_ratio    = 0.1
    enable_geo_fencing_for_backups  = true

```