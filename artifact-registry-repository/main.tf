resource "google_artifact_registry_repository_iam_binding" "binding" {

    for_each    = var.iam_bindings
    project     = var.project_id
    location    = var.location
    repository  = google_artifact_registry_repository.artifacts_repo.name
    role        = each.key
    members     = each.value

    depends_on = [
        google_artifact_registry_repository.artifacts_repo
    ]    
}

resource "google_artifact_registry_repository" "artifacts_repo" {
    
    location        = var.location
    repository_id   = var.repo_id
    description     = var.description
    format          = var.repo_type
    labels          = var.labels
    project         = var.project_id

    kms_key_name    = var.kms_key_name
}

