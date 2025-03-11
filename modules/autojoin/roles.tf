resource "google_project_iam_custom_role" "autoloader_gcs_reader" {
  description = "autolaoder-gcs-reader"
  # NOTE: permissions mirror the set used by legacy reader, a role that cannot
  # be assigned to service accounts.
  permissions = [
    "storage.buckets.get",
    "storage.managedFolders.get",
    "storage.managedFolders.list",
    "storage.multipartUploads.list",
    "storage.objects.list",
  ]
  role_id     = "autoloader_gcs_access"
  stage       = "GA"
  title       = "autoloader-gcs-reader"
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

resource "google_project_iam_member" "autonode_gke_artifact_registry_access" {
  role = "roles/artifactregistry.reader"
  member = "serviceAccount:${google_service_account.gke.email}"
  project = data.google_client_config.current.project
}

resource "google_project_iam_member" "autonode_gke_container_registry_access" {
  role = "roles/containerregistry.ServiceAgent"
  member = "serviceAccount:${google_service_account.gke.email}"
  project = data.google_client_config.current.project
}

resource "google_project_iam_member" "autonode_gke_default_node_permissions" {
  role = "roles/container.defaultNodeServiceAccount"
  member = "serviceAccount:${google_service_account.gke.email}"
  project = data.google_client_config.current.project
}

resource "google_project_iam_member" "autonode_gke_gcs_reader" {
  role = "${google_project_iam_custom_role.autoloader_gcs_reader.id}"
  member = "serviceAccount:${google_service_account.gke.email}"
  project = data.google_client_config.current.project
}

resource "google_project_iam_member" "autonode_gke_bigquery_updater" {
  role = "roles/bigquery.dataEditor"
  member = "serviceAccount:${google_service_account.gke.email}"
  project = data.google_client_config.current.project
}

resource "google_project_iam_member" "autonode_gke_bigquery_user" {
  role = "roles/bigquery.user"
  member = "serviceAccount:${google_service_account.gke.email}"
  project = data.google_client_config.current.project
}

resource "google_project_iam_member" "autonode_gke_bigquery_viewer" {
  role = "roles/bigquery.dataViewer"
  member = "serviceAccount:${google_service_account.gke.email}"
  project = data.google_client_config.current.project
}

