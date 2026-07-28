# Dataset read access for automations from the m-lab/automations repository.
# Robot service accounts get dataset-level grants here; humans get BigQuery
# access through the discuss@measurementlab.net group instead.

# ndt-upgrade-sync reads the last day of ndt7 autoload data to compute
# per-org upgrade status.
resource "google_bigquery_dataset_iam_member" "ndt_upgrade_sync_autoload_reader" {
  dataset_id = "autojoin_autoload_v2_ndt"
  role       = "roles/bigquery.dataViewer"
  member     = "serviceAccount:ndt-upgrade-sync@mlab-sandbox.iam.gserviceaccount.com"
}
