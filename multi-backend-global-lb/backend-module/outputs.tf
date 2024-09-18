output "backend_ids" {
  # value = [
  #   for backends in google_compute_backend_service.backend :
  #   backends.id
  # ]
  value = [
    for backends in google_compute_backend_service.backend :backends.id
  ]

  description = "Unique IDs for any backends being provisioned"
}