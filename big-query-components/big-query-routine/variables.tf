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


variable "project_id" {
  description = "Project where the dataset and table are created"
  type        = string
}

variable "bq_dataset_id" {
  description = "BigQuery Dataset ID in which the table will be created."
  type        = string
}

variable "routines" {
  description = "A list of objects which include routine_id, routine_type, routine_language, definition_body, return_type, routine_description and arguments."
  default     = []
  type = list(object({
    routine_id      = string,
    routine_type    = string,
    language        = string,
    definition_body = string,
    return_type     = string,
    description     = string,
    arguments = list(object({
      name          = string,
      data_type     = string,
      argument_kind = string,
      mode          = string,
    })),
  }))
}