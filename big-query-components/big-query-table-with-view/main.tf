/**
 * Copyright 2022 Google LLC
 *
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 *      http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */

locals {
  tables             = { for table in var.tables : table["table_id"] => table }

}

resource "google_bigquery_table" "table_with_view" {
  for_each            = local.tables
  dataset_id          = var.bq_dataset_id 
  friendly_name       = each.value["friendly_name"]
  table_id            = each.key
  labels              = each.value["labels"]
  schema              = each.value["schema"]
  expiration_time     = each.value["expiration_time"]
  project             = var.project_id
  deletion_protection = var.bq_table_deletion_protection

  dynamic "view" {
    for_each  = each.value["view"] != null ? [each.value["view"]] : []

    content {
      query = lookup(each.value["view"], "query", "")
      use_legacy_sql = lookup(each.value["view"], "use_legacy_sql", false)
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
