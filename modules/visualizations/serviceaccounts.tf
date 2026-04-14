#
# Service Accounts
#
resource "google_service_account" "grafana_public" {
  account_id   = "grafana-public"
  description  = "Account for public Grafana instance. Member of discuss@"
  display_name = "grafana-public"
}

#
# Role Bindings
#
resource "google_project_iam_member" "logging_logwriter" {
  project = data.google_project.current.id
  role    = "roles/logging.logWriter"
  member  = "serviceAccount:grafana-public@${data.google_project.current.project_id}.iam.gserviceaccount.com"
}

resource "google_project_iam_member" "cloudtrace_agent" {
  project = data.google_project.current.id
  role    = "roles/cloudtrace.agent"
  member  = "serviceAccount:grafana-public@${data.google_project.current.project_id}.iam.gserviceaccount.com"
}

resource "google_project_iam_member" "monitoring_metricwriter" {
  project = data.google_project.current.id
  role    = "roles/monitoring.metricWriter"
  member  = "serviceAccount:grafana-public@${data.google_project.current.project_id}.iam.gserviceaccount.com"
}

resource "google_project_iam_member" "monitoring_metricsscopesviewer" {
  project = data.google_project.current.id
  role    = "roles/monitoring.metricsScopesViewer"
  member  = "serviceAccount:grafana-public@${data.google_project.current.project_id}.iam.gserviceaccount.com"
}

resource "google_project_iam_member" "storage_objectviewer" {
  project = data.google_project.current.id
  role    = "roles/storage.objectViewer"
  member  = "serviceAccount:grafana-public@${data.google_project.current.project_id}.iam.gserviceaccount.com"
}

resource "google_project_iam_member" "artifactregistry_reader" {
  project = data.google_project.current.id
  role    = "roles/artifactregistry.reader"
  member  = "serviceAccount:grafana-public@${data.google_project.current.project_id}.iam.gserviceaccount.com"
}
