

 resource "google_bigquery_table" "materialized_view" {
  for_each = {
    for n in var.materialized_views :
    n.table_id => n
  }

  dataset_id          = var.bq_dataset_id
  table_id            = each.value.table_id
  project             = var.project_id
  description         = lookup(each.value, "description", null)
  expiration_time     = lookup(each.value, "expiration_time", null)
  friendly_name       = each.value.table_id
  labels              = each.value["labels"]
  schema              = each.value.table_schema
  deletion_protection = var.bq_table_deletion_protection

  dynamic "materialized_view" {
    for_each = each.value.materialized_view

    content {
      query               = materialized_view.value.query
      enable_refresh      = materialized_view.value.enable_refresh
      refresh_interval_ms = materialized_view.value.refresh_interval_ms

    }
    
  }

 }




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

# locals {
#   materialized_views = { for mat_view in var.materialized_views : mat_view["view_id"] => mat_view }

# }

# resource "google_bigquery_table" "materialized_view" {
#   for_each            = local.materialized_views
#   dataset_id          = var.bq_dataset_id
#   friendly_name       = each.key
#   table_id            = each.key
#   labels              = each.value["labels"]
#   clustering          = each.value["clustering"]
#   expiration_time     = each.value["expiration_time"]
#   project             = var.project_id
#   deletion_protection = var.bq_table_deletion_protection

#   dynamic "time_partitioning" {
#     for_each = each.value["time_partitioning"] != null ? [each.value["time_partitioning"]] : []
#     content {
#       type                     = time_partitioning.value["type"]
#       expiration_ms            = time_partitioning.value["expiration_ms"]
#       field                    = time_partitioning.value["field"]
#       require_partition_filter = time_partitioning.value["require_partition_filter"]
#     }
#   }

#   dynamic "range_partitioning" {
#     for_each = each.value["range_partitioning"] != null ? [each.value["range_partitioning"]] : []
#     content {
#       field = range_partitioning.value["field"]
#       range {
#         start    = range_partitioning.value["range"].start
#         end      = range_partitioning.value["range"].end
#         interval = range_partitioning.value["range"].interval
#       }
#     }
#   }

#   materialized_view {
#     query               = each.value["query"]
#     enable_refresh      = each.value["enable_refresh"]
#     refresh_interval_ms = each.value["refresh_interval_ms"]
#   }

#   lifecycle {
#     ignore_changes = [
#       encryption_configuration # managed by google_bigquery_dataset.main.default_encryption_configuration
#     ]
#   }
# }