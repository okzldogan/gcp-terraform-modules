resource "google_dns_record_set" "weighted_routing_policy" {

  project      = var.project_id
  name         = "${var.dns_entry_name}.${var.domain_name}"
  managed_zone = var.zone_name
  type         = var.dns_record_type
  ttl          = var.TTL

  routing_policy {
    dynamic "wrr" {
      for_each = var.weighted_routing_config

      content {
        weight  = lookup(wrr.value, "weight", null)
        rrdatas = lookup(wrr.value, "rrdatas", null)
      }
    }
  }

}