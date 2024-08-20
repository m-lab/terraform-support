resource "google_service_account" "autonode" {
  account_id   = "autonode"
  display_name = "Custom SA for the autonode VM instance (managed by Terraform)"
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
