resource "google_folder" "folders" {

  display_name  = var.folder_name
  parent        = var.parent
}


resource "google_folder_iam_binding" "bindings" {

  for_each  = var.folder_iam_bindings
  folder    = google_folder.folders.name

  role      = each.key
  members   = each.value

  depends_on = [google_folder.folders]
}

