This module creates a table or multiple tables in the referred bigquery dataset WITH the view option.

Below you can find an example, you can pass in other values as required for your configuration.

 ######################################
 ##### Example Use of the Module ######
 ######################################

module "bigquery_dataset_components" {
  source  = "../../../infra/terraform-modules/big-query-components/big-query-table-with-view"

  bq_dataset_id                 = "<bq-dataset-id>"
  project_id                    = "<project-id>"
  bq_table_deletion_protection  = <true or false> # false permits deleting the table(s) using terraform.


  tables = [
    {
        table_id        = "client_time_rates"

        friendly_name   = "client_time_rates"

        schema          = <<EOF
        [
            {
                "name": "user_id",
                "type": "INTEGER",
                "mode": "NULLABLE"
            },
            {
                "name": "cs_id",
                "type": "INTEGER",
                "mode": "NULLABLE"
            },
            {
                "name": "cs_type",
                "type": "STRING",
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

        view = {
            query          = "SELECT DISTINCT organization, SUM(CAST(response_text AS DECIMAL)) AS Scope_emissions FROM `marketk8.cdp.cdp_emissions_analytics`\r\nwhere ((code = 'C7.5' AND question_code = 'C3') OR (code = 'C7.5' AND question_code = 'C2') OR (code = 'C7.2' AND question_code = 'C2'))\r\nGROUP BY organization"

            use_legacy_sql  = false
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
        table_id        = "org_emissions"

        friendly_name   = "org_emissions"

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
        view = {
            query          = <<EOF
            SELECT
            column_a,
            column_b,
            FROM
                `marketk8.cdp.cdp_emissions_analytics`
            WHERE
                approved_user = SESSION_USER
            EOF

            use_legacy_sql  = false
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
