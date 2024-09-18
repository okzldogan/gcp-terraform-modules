output "table_ids" {
  value = [
    for table in google_bigquery_table.table_only :
    table.table_id
  ]
  description = "Unique id for the table being provisioned"
}

output "table_names" {
  value = [
    for table in google_bigquery_table.table_only :
    table.friendly_name
  ]
  description = "Friendly name for the table being provisioned"
}