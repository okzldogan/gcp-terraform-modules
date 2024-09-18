resource "google_dns_record_set" "geolocation_routing_policy" {

  project      = var.project_id
  name         = "${var.dns_entry_name}.${var.domain_name}"
  managed_zone = var.zone_name
  type         = var.dns_record_type
  ttl          = var.TTL

  routing_policy {
    dynamic "geo" {
      for_each = var.geolocation_routing_config

      content {
        location  = lookup(geo.value, "location", null)
        rrdatas   = lookup(geo.value, "rrdatas", null)
      }
    }
  }

}