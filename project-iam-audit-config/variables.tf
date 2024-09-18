variable "project_id" {
  description = "Project id"
  type        = string
}

variable project_audit_logs_config {
    type = list(object({
        service_name = string
        log_types = list(string)
    }))
}
