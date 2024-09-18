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
  routines           = { for routine in var.routines : routine["routine_id"] => routine }

}


resource "google_bigquery_routine" "routine" {
  for_each        = local.routines

  dataset_id      = var.bq_dataset_id
  project         = var.project_id
  
  routine_id      = each.key
  definition_body = each.value["definition_body"]
  routine_type    = each.value["routine_type"]
  language        = each.value["language"]
  description     = each.value["description"]

  dynamic "arguments" {
    for_each = each.value["arguments"] != null ? each.value["arguments"] : []
    content {
      name          = arguments.value["name"]
      data_type     = arguments.value["data_type"]
      mode          = arguments.value["mode"]
      argument_kind = arguments.value["argument_kind"]
    }
  }

  return_type = each.value["return_type"]
}