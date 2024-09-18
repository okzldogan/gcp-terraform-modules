locals {
  tables             = { for table in var.tables : table["table_id"] => table }
}

resource "google_bigquery_table" "table_only" {
  for_each            = local.tables
  dataset_id          = var.bq_dataset_id 
  friendly_name       = each.key
  table_id            = each.key
  labels              = each.value["labels"]
  schema              = each.value["schema"]
  clustering          = each.value["clustering"]
  expiration_time     = each.value["expiration_time"]
  project             = var.project_id
  deletion_protection = var.bq_table_deletion_protection


  dynamic "time_partitioning" {
    for_each = each.value["time_partitioning"] != null ? [each.value["time_partitioning"]] : []
    content {
      type                     = time_partitioning.value["type"]
      expiration_ms            = time_partitioning.value["expiration_ms"]
      field                    = time_partitioning.value["field"]
      require_partition_filter = time_partitioning.value["require_partition_filter"]
    }
  }

  dynamic "range_partitioning" {
    for_each = each.value["range_partitioning"] != null ? [each.value["range_partitioning"]] : []
    content {
      field = range_partitioning.value["field"]
      range {
        start    = range_partitioning.value["range"].start
        end      = range_partitioning.value["range"].end
        interval = range_partitioning.value["range"].interval
      }
    }
  }

  lifecycle {
    ignore_changes = [
      encryption_configuration # managed by google_bigquery_dataset.main.default_encryption_configuration
    ]
  }
}