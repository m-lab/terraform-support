# Secret shells only; values are added out of band by whoever holds the
# credential, e.g.:
#   gcloud secrets versions add <name>-<secret> --data-file=- --project=<project>
resource "google_secret_manager_secret" "secrets" {
  for_each = toset(var.secrets)

  secret_id = "${var.name}-${each.value}"

  replication {
    auto {}
  }
}

resource "google_secret_manager_secret_iam_member" "secret_access" {
  for_each = google_secret_manager_secret.secrets

  secret_id = each.value.id
  role      = "roles/secretmanager.secretAccessor"
  member    = "serviceAccount:${google_service_account.service.email}"
}
