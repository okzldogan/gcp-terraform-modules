This module creates an external table or multiple external tables in the referred bigquery dataset.

Below you can find an example, you can pass in other values as required for your configuration.

 ######################################
 ##### Example Use of the Module ######
 ######################################


module "bigquery_dataset_components" {
  source  = "../../../infra/terraform-modules/big-query-components/big-query-external-table"

  bq_dataset_id                 = "<bq-dataset-id"
  project_id                    = "<project-id>"
  bq_table_deletion_protection  = false # false permits you the delete the table using terraform

  external_tables = [
    {
        table_id        = "project_scope_mapping"
        table_schema    = "[{\"mode\":\"NULLABLE\",\"name\":\"Verra\",\"type\":\"STRING\"},{\"mode\":\"NULLABLE\",\"name\":\"GS\",\"type\":\"STRING\"},{\"mode\":\"NULLABLE\",\"name\":\"CAR\",\"type\":\"STRING\"},{\"mode\":\"NULLABLE\",\"name\":\"ACR\",\"type\":\"STRING\"},{\"mode\":\"NULLABLE\",\"name\":\"SP_Scope\",\"type\":\"STRING\"},{\"mode\":\"NULLABLE\",\"name\":\"SP_Technology\",\"type\":\"STRING\"}]"

        expiration_time = null
        
        labels = {
            env = "dev"
        }

        external_data_configuration = [
            {
                autodetect = false
                source_format = "GOOGLE_SHEETS"
                source_uris   = ["https://docs.google.com/spreadsheets/d/1SvTEOR_gNQeH4MiKma0JSAKsoGUSeC9nWneh7CIlcUM/edit?usp=sharing"]

                google_sheets_options = {
                    range = "Project Map!A1:F48"
                    skip_leading_rows = 1
                }
            }
        ]
    },
    {
        table_id        = "country_map"
        table_schema    = "[{\"mode\":\"NULLABLE\",\"name\":\"Verra\",\"type\":\"STRING\"},{\"mode\":\"NULLABLE\",\"name\":\"GS\",\"type\":\"STRING\"},{\"mode\":\"NULLABLE\",\"name\":\"CAR\",\"type\":\"STRING\"},{\"mode\":\"NULLABLE\",\"name\":\"ACR\",\"type\":\"STRING\"},{\"mode\":\"NULLABLE\",\"name\":\"SP\",\"type\":\"STRING\"},{\"mode\":\"NULLABLE\",\"name\":\"Region\",\"type\":\"STRING\"}]"

        expiration_time = null

        labels = {
            env = "dev"
        }

        external_data_configuration = [
            {
                autodetect = false
                compression = "GZIP"
                source_format = "GOOGLE_SHEETS"
                source_uris   = ["https://docs.google.com/spreadsheets/d/1k-c2oQzcaae0VrITGofuc2QaB-t4eVOUMNTBi-G991o/edit?usp=sharing"]

                google_sheets_options = {
                    range = "Country Map!A1:F137"
                    skip_leading_rows = 1
                }
            }
        ]
    }

  ]
}