
resource "google_project_iam_custom_role" "project_custom_role" {
  role_id     = var.custom_role_id
  project     = var.project_id
  title       = var.custom_role_title
  description = var.custom_role_description
  permissions = var.custom_role_permissions
  stage       = var.stage
}


/******************************************
  Assigning custom_role to member
 *****************************************/
resource "google_project_iam_member" "custom_role_member" {

  for_each = toset(var.members)
  project  = var.project_id
  role     = "projects/${var.project_id}/roles/${google_project_iam_custom_role.project_custom_role.role_id}"
  member   = each.key

  depends_on = [
    google_project_iam_custom_role.project_custom_role
  ]
}
