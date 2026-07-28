output "service_account_email" {
  description = "Email of the automation's runtime service account."
  value       = google_service_account.service.email
}

output "secret_ids" {
  description = "Fully qualified ids of the created secrets."
  value       = [for s in google_secret_manager_secret.secrets : s.id]
}
