resource "google_storage_bucket_iam_binding" "binding" {
    for_each    = var.bindings
    bucket      = var.bucket_name
    role        = each.key
    members      = each.value

    dynamic "condition" {
        for_each = var.condition != null ? [var.condition] : []
        content {
        title       = lookup(var.condition, "title", null)
        description = lookup(var.condition, "description", null)
        expression  = lookup(var.condition, "expression", null)
        }
    }

}
