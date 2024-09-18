This module creates a primary backup routing policy dns entry.

 ######################################
 ##### Example Use of the Module ######
 ######################################



module "primary_backup_routing_policy_dns_entry" {
    source          = "../../../terraform-modules/dns-entry/primary-backup-policy/"      # Commented for Future Use                    

    project_id                  = "<project-id>"
    zone_name                   = "<zone-name>"

    domain_name                 = "example.local."      # "Final character with a dot"

    dns_entry_name              = "test"
    TTL                         = 300
    dns_record_type             = "A"

    ILB_IP_ADDRESS              = "10.200.1.1"
    ILB_network_url             = "projects/${var.prefix}-${var.name}/global/networks/sp-shared-vpc-dev"
    ILB_project_id              = "${var.prefix}-${var.name}"
    ILB_region                  = "europe-west1"

    primary_backup_trickle_ratio    = 0.1
    enable_geo_fencing_for_backups  = true