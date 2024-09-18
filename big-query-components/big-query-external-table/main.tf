

 resource "google_bigquery_table" "external_table" {
  for_each = {
    for n in var.external_tables :
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

  dynamic "external_data_configuration" {
    for_each = each.value.external_data_configuration #lookup(each.value, "external_data_configuration", [])

    content {
      autodetect      = external_data_configuration.value.autodetect
      compression     = lookup(external_data_configuration.value, "compression", "NONE")#lookup(each.value.external_data_configuration.value, "compression", null) #lookup(external_data_configuration.value, "compression", null) #external_data_configuration.value["compression"] != null ? external_data_configuration.value["compression"] : null #external_data_configuration.value["compression"] #lookup(external_data_configuration.value, "compression", null)
      source_format   = external_data_configuration.value.source_format
      source_uris     = external_data_configuration.value.source_uris

      dynamic "google_sheets_options" {
        for_each = external_data_configuration.value["source_format"] == "GOOGLE_SHEETS" ? [external_data_configuration.value["google_sheets_options"]] : []

        content {
          range             = google_sheets_options.value["range"]
          skip_leading_rows = google_sheets_options.value["skip_leading_rows"]
        }
      }

      dynamic "csv_options" {
        for_each = external_data_configuration.value["source_format"] == "CSV" ? [external_data_configuration.value["csv_options"]] : []

        content {
          quote                 = csv_options.value["quote"]
          allow_jagged_rows     = csv_options.value["allow_jagged_rows"]
          allow_quoted_newlines = csv_options.value["allow_quoted_newlines"]
          encoding              = csv_options.value["encoding"]
          field_delimiter       = csv_options.value["field_delimiter"]
          skip_leading_rows     = csv_options.value["skip_leading_rows"]
        }
      }

    }
    
  }

 }
