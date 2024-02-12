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
resource "google_project_iam_binding" "logging_logwriter" {
  project = data.google_project.current.id
  role    = "roles/logging.logWriter"

  members = [
    "serviceAccount:grafana-public@${data.google_project.current.project_id}.iam.gserviceaccount.com"
  ]
}

resource "google_project_iam_binding" "cloudtrace_agent" {
  project = data.google_project.current.id
  role    = "roles/cloudtrace.agent"

  members = [
    "serviceAccount:grafana-public@${data.google_project.current.project_id}.iam.gserviceaccount.com"
  ]
}

resource "google_project_iam_binding" "monitoring_metricwriter" {
  project = data.google_project.current.id
  role    = "roles/monitoring.metricWriter"

  members = [
    "serviceAccount:grafana-public@${data.google_project.current.project_id}.iam.gserviceaccount.com"
  ]
}

resource "google_project_iam_binding" "monitoring_metricsscopesviewer" {
  project = data.google_project.current.id
  role    = "roles/monitoring.metricsScopesViewer"

  members = [
    "serviceAccount:grafana-public@${data.google_project.current.project_id}.iam.gserviceaccount.com"
  ]
}

resource "google_project_iam_binding" "storage_objectviewer" {
  project = data.google_project.current.id
  role    = "roles/storage.objectViewer"

  members = [
    "serviceAccount:grafana-public@${data.google_project.current.project_id}.iam.gserviceaccount.com"
  ]
}

resource "google_project_iam_binding" "artifactregistry_reader" {
  project = data.google_project.current.id
  role    = "roles/artifactregistry.reader"

  members = [
    "serviceAccount:grafana-public@${data.google_project.current.project_id}.iam.gserviceaccount.com"
  ]
}
