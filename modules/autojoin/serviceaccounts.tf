resource "google_service_account" "autonode" {
  account_id   = "autonode"
  description = "Custom SA for the autonode VM instance (managed by Terraform)"
  display_name = "Autonode VM SA"
}

resource "google_service_account" "gke" {
  account_id   = "autojoin-gke"
  description = "Default SA for the autojoin GKE cluster node pools (managed by Terraform)"
  display_name = "Autojoin GKE SA"
}

resource "google_storage_bucket_iam_member" "autonode_access" {
  bucket = "archive-${data.google_client_config.current.project}"
  role = "roles/storage.objectAdmin"
  member = "serviceAccount:${google_service_account.autonode.email}"
}

resource "google_storage_bucket_iam_member" "autonode_access_downloader" {
  bucket = "downloader-${data.google_client_config.current.project}"
  role = "roles/storage.objectViewer"
  member = "serviceAccount:${google_service_account.autonode.email}"
}
