This module creates a table or multiple tables in the referred bigquery dataset without the view option. Refer to "big-query-table-with-view" module to use create tables with view option.

Below you can find an example, you can pass in other values as required for your configuration.

 ######################################
 ##### Example Use of the Module ######
 ######################################

module "bigquery_dataset_components" {
  source  = "../../../infra/terraform-modules/big-query-components/big-query-table-only"

  bq_dataset_id                 = "<bq-dataset-id>"
  project_id                    = "<project-id>"
  bq_table_deletion_protection  = <true or false> # false permits you the delete the table using terraform


  tables = [
    {
        table_id        = "principals"

        friendly_name   = "principals"

        schema          = <<EOF
        [
            {
                "name": "id",
                "type": "STRING",
                "mode": "NULLABLE"
            },
            {
                "name": "account_number",
                "type": "INTEGER",
                "mode": "NULLABLE"
            },
            {
                "name": "organization",
                "type": "INTEGER",
                "mode": "NULLABLE"
            }
        ]
        EOF

        time_partitioning = {

            type                     = "DAY",
            field                    = null,
            require_partition_filter = false,
            expiration_ms            = null,

        }

        range_partitioning  = null
        expiration_time     = null

        clustering          = [
            "fullVisitorId",
            "visitId"
        ],

        labels = {
            env         = "dev"
            billable    = "true"
            owner       = "data-team"
        }
    },
    {
        table_id    = "country_emissions"

        schema      = "[{\"mode\":\"NULLABLE\",\"name\":\"country\",\"type\":\"STRING\"},{\"mode\":\"NULLABLE\",\"name\":\"Scope_emissions\",\"type\":\"NUMERIC\"}]"  # You can write the schema also in this format.

        time_partitioning   = null

        range_partitioning  = {
            field   = "customer_id"
            range   = {
                start       = "1"
                end         = "100"
                interval    = "10"
            }
        }

        expiration_time     = null

        clustering          = []

        labels  = {
            env         = "dev"
            billable    = "true"
            owner       = "data-team"
        }
    }

  ]

}