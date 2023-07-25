# The default GCE service account.
data "google_compute_default_service_account" "default" {}

# Allow us to access the project ID and number.
data "google_project" "project" {}
