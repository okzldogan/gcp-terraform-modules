resource "google_dns_record_set" "primary_backup_routing_policy" {

  project      = var.project_id
  name         = "${var.dns_entry_name}.${var.domain_name}"
  managed_zone = var.zone_name
  type         = var.dns_record_type
  ttl          = var.TTL

  routing_policy {

    primary_backup {

        primary {
            internal_load_balancers {
                load_balancer_type  = "regionalL4ilb"
                ip_address          = var.ILB_IP_ADDRESS
                port                = "80"
                ip_protocol         = "tcp"
                network_url         = var.ILB_network_url
                project             = var.ILB_project_id
                region              = var.ILB_region
            }
        }

        dynamic "backup_geo" {
            for_each    = var.backup_geo_config

            content {
                location    = lookup(backup_geo.value, "location", null)
                rrdatas     = lookup(backup_geo.value, "rrdatas", null)
            }
        }

        trickle_ratio                   = var.primary_backup_trickle_ratio
        enable_geo_fencing_for_backups  = var.enable_geo_fencing_for_backups
    }


  }

}