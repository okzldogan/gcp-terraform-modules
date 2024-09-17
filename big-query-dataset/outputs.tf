output "bigquery_dataset" {
  value       = google_bigquery_dataset.dataset
  description = "The created BigQuery dataset resource."
}