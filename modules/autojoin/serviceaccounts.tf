resource "google_service_account" "autonode" {
  account_id   = "autonode"
  display_name = "Custom SA for the autonode VM instance (managed by Terraform)"
}

resource "google_storage_bucket_iam_member" "autonode_access" {
  bucket = "archive-mlab-sandbox"
  role = "roles/storage.objectAdmin"
  member = "serviceAccount:${google_service_account.autonode.email}"
}