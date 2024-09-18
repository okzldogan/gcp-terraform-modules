resource "google_project_iam_binding" "project" {
  for_each  = toset(var.roles)
  project   = var.project_id
  role      = each.key

  members = var.members

  dynamic "condition" {
    for_each = var.condition != null ? [var.condition] : []
    content {
      title       = lookup(var.condition, "title", null)
      description = lookup(var.condition, "description", null)
      expression  = lookup(var.condition, "expression", null)
    }
  }

}
