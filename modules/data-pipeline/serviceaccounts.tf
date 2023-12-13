resource "google_service_account" "stats_pipeline" {
  account_id   = "stats-pipeline"
  description  = "Account for stats-pipeline. R/W access to GCS and BQ"
  display_name = "stats-pipeline"
}
