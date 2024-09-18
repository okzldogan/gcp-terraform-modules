resource "google_compute_region_disk" "regional_persistent_disk" {
  name            = var.regional_disk_name
  description     = var.regional_disk_description
  labels          = var.regional_disk_labels
  size            = var.regional_disk_size
  type            = var.regional_disk_type
  replica_zones   = var.disk_replica_zones
  region          = var.disk_region
  project         = var.regional_disk_project_id

  dynamic "disk_encryption_key" {
    for_each  = var.use_encryption_key ? [1] : []

    content {
      kms_key_name = var.kms_key_name
    }
  }


}

