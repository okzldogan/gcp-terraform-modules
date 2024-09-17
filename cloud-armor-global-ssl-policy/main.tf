resource "google_compute_ssl_policy" "ssl_policy" {
    
    name            = var.ssl_policy_name
    description     = var.ssl_policy_description
    min_tls_version = var.min_tls_version
    profile         = var.ssl_policy_type
    custom_features = var.ssl_policy_type == "CUSTOM" ? var.custom_features : null
    project         = var.project_id
}