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



output "bigquery_external_tables" {
  value       = google_bigquery_table.external_table
  description = "Map of BigQuery external table resources being provisioned."
}

output "external_table_ids" {
  value = [
    for external_table in google_bigquery_table.external_table :
    external_table.table_id
  ]
  description = "Unique IDs for any external tables being provisioned"
}

output "external_table_names" {
  value = [
    for table in google_bigquery_table.external_table :
    table.friendly_name
  ]
  description = "Friendly names for any external tables being provisioned"
}

