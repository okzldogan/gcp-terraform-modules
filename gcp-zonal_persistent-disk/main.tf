resource "google_compute_disk" "zonal_persistent_disk" {

  provider      = google-beta
  name          = var.disk_name
  description   = var.disk_description
  labels        = var.disk_labels
  size          = var.disk_size
  type          = var.disk_type
  zone          = var.disk_zone

  project       = var.disk_project_id

  provisioned_iops = var.provisioned_iops

  multi_writer     = var.multi_writer

  dynamic "disk_encryption_key" {
    for_each  = var.use_encryption_key ? [1] : []

    content {
      kms_key_self_link = var.kms_key_self_link
    }
  }

}

 