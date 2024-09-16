output "artifacts_repo_name" {
  value       = google_artifact_registry_repository.artifacts_repo.name
  description = "Name of the artifacts registry repo"
}