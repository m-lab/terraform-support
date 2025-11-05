# The default GCE service account.
data "google_compute_default_service_account" "default" {}

# Allow us to access the project ID and number.
data "google_project" "project" {}

# Data about the current environment, which includes project, zone and region.
data "google_client_config" "current" {}
