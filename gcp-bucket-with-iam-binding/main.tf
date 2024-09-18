#####################################################
##### Create Random String for Unique Bucket ID #####
#####################################################

resource "random_string" "suffix" {
  length  = 4
  upper   = false
  lower   = false
  numeric = true
  special = false
}

#############################
##### Create the Bucket #####
#############################


resource "google_storage_bucket" "bucket" {

  name            = "${var.project_id}-${var.bucket_id}-${random_string.suffix.result}"  # Every bucket name must be globally unique
  location        = var.bucket_location
  project         = var.project_id
  storage_class   = var.storage_class

  force_destroy   = var.force_destroy

  labels          = var.bucket_labels

  public_access_prevention    = var.public_access_prevention
  uniform_bucket_level_access = true

  dynamic "custom_placement_config" {
    for_each = var.dual_region == null ? [] : [var.dual_region]
    content {
      data_locations = var.dual_region.data_locations
    }
  }

  dynamic "cors" {
    for_each = var.cors_config

    content {
      origin          = lookup(cors.value, "origin", null)
      method          = lookup(cors.value, "method", null)
      response_header = lookup(cors.value, "response_header", null)
      max_age_seconds = lookup(cors.value, "max_age_seconds", null)
    }
  }

  dynamic "lifecycle_rule" {

    for_each = var.lifecycle_rules

    content {

      action {
        type          = lifecycle_rule.value.action.type
        storage_class = lookup(lifecycle_rule.value.action, "storage_class", null)
      }

      condition {
        age                        = lookup(lifecycle_rule.value.condition, "age", null)
        created_before             = lookup(lifecycle_rule.value.condition, "created_before", null)
        with_state                 = lookup(lifecycle_rule.value.condition, "with_state", lookup(lifecycle_rule.value.condition, "is_live", false) ? "LIVE" : null)
        matches_storage_class      = contains(keys(lifecycle_rule.value.condition), "matches_storage_class") ? split(",", lifecycle_rule.value.condition["matches_storage_class"]) : null
        num_newer_versions         = lookup(lifecycle_rule.value.condition, "num_newer_versions", null)
        custom_time_before         = lookup(lifecycle_rule.value.condition, "custom_time_before", null)
        days_since_custom_time     = lookup(lifecycle_rule.value.condition, "days_since_custom_time", null)
        days_since_noncurrent_time = lookup(lifecycle_rule.value.condition, "days_since_noncurrent_time", null)
        noncurrent_time_before     = lookup(lifecycle_rule.value.condition, "noncurrent_time_before", null)
      }
    }
  }
  versioning {
    enabled = var.versioning
  }

  depends_on = [
      random_string.suffix
  ]

}

############################################################
##### Grant Permissions to the Bucket with IAM Binding #####
############################################################

resource "google_storage_bucket_iam_binding" "binding" {

  for_each    = var.bindings
  bucket      = google_storage_bucket.bucket.name
  role        = each.key
  members     = each.value

  dynamic "condition" {
      for_each = var.condition != null ? [var.condition] : []
      content {
      title       = lookup(var.condition, "title", null)
      description = lookup(var.condition, "description", null)
      expression  = lookup(var.condition, "expression", null)
      }
  }

  depends_on = [
      google_storage_bucket.bucket
  ]

}

############################################
##### Create Folders Inside the Bucket #####
############################################

resource "google_storage_bucket_object" "folders" {

  for_each = toset(var.bucket_folders)

  bucket   = google_storage_bucket.bucket.name
  # Declaring an object with a '/' creates a directory

  name     = "${each.key}/" 
  # The the content string is not actually used
  # It is required by the GCP API

  content  = "no-value"  

  depends_on = [
      google_storage_bucket.bucket
  ]

}