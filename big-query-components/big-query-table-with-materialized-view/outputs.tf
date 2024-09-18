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

output "bigquery_tables" {
  value       = google_bigquery_table.materialized_view
  description = "Map of bigquery table resources being provisioned."
}


output "table_ids" {
  value = [
    for table in google_bigquery_table.materialized_view :
    table.table_id
  ]
  description = "Unique id for the table being provisioned"
}

output "table_names" {
  value = [
    for table in google_bigquery_table.materialized_view :
    table.friendly_name
  ]
  description = "Friendly name for the table being provisioned"
}
