locals {
    project_audit_logs = {
        for items in var.project_audit_logs_config:
            items.service_name => items
   
    }
}


resource "google_project_iam_audit_config" "project" {

    for_each    = local.project_audit_logs


    project     = var.project_id
    service     = "${each.value.service_name}"


    dynamic "audit_log_config" {
        for_each = each.value.log_types
        content {
            log_type = audit_log_config.value
        }}  
    
}