resource "google_artifact_registry_repository" "build_images" {
  location      = "us-central1"
  repository_id = "build-images"
  description   = "Cloud Build container images"
  format        = "DOCKER"
}

resource "google_artifact_registry_repository_iam_member" "member" {
  location   = google_artifact_registry_repository.build_images.location
  repository = google_artifact_registry_repository.build_images.name
  role       = "roles/artifactregistry.reader"
  member     = "allUsers"
}
