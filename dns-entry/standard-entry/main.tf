
resource "google_dns_record_set" "standard" {

  project       = var.project_id
  managed_zone  = var.zone_name

  for_each      = { for record in var.recordsets : join("/", [record.name, record.type]) => record }
  name          = (
    each.value.name != "" ?
    "${each.value.name}.${var.domain_name}" :
    var.domain_name
  )

  type          = each.value.type
  ttl           = each.value.ttl

  rrdatas       = each.value.records
}
