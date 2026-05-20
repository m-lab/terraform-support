# Allow the Cloud Build service account to IAP-tunnel into the monitoring VM
# for config deployment.
resource "google_iap_tunnel_instance_iam_member" "cloudbuild" {
  instance = google_compute_instance.monitoring.name
  member   = "serviceAccount:${data.google_project.project.number}@cloudbuild.gserviceaccount.com"
  role     = "roles/iap.tunnelResourceAccessor"
  zone     = var.zone
}
