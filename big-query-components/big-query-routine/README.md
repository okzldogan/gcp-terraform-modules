 
 This module create a big query routine or multiple routines.

 You can pass in other values, the below is just for example purposes.

 ######################################
 ##### Example Use of the Module ######
 ######################################

module "bigquery_dataset_components" {
  source  = "../../../infra/terraform-modules/big-query-components/big-query-routine"

  bq_dataset_id                 = "<dataset-id>"
  project_id                    = "<project-id>"

  routines = [
    {
        routine_id          = "users"

        definition_body = <<-EOS
            SELECT 1 + value AS value
        EOS
        
        routine_type        = "TABLE_VALUED_FUNCTION"
        language            = "SQL"

        description = "test"

        arguments = [
            {
                name            = "value"
                data_type       = jsonencode({ "typeKind" : "INT64" })   
                argument_kind   = "FIXED_TYPE"
                mode            = "IN"
            }
        ]

        return_type = "{\"typeKind\" :  \"FLOAT64\"}"

    },

  ]
}