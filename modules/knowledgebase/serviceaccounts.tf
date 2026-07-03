#
# Service Accounts
#
resource "google_service_account" "kb_query_tests" {
  account_id   = "kb-query-tests"
  description  = "Validates BigQuery SQL in knowledgebase articles with dry-run queries from GitHub Actions. Member of discuss@"
  display_name = "kb-query-tests"
}

#
# Role Bindings
#
# Same project-level role that members of discuss@measurementlab.net have.
# Dataset-level access comes from adding this account to the discuss@ group,
# like grafana-public.
resource "google_project_iam_member" "public_bigquery_user" {
  project = data.google_project.current.id
  role    = "projects/${data.google_project.current.project_id}/roles/public_bigquery_user_project_level"
  member  = "serviceAccount:${google_service_account.kb_query_tests.email}"
}

# Allow GitHub Actions workflows in m-lab/knowledgebase to impersonate this
# account through the "github" Workload Identity Pool in mlab-testing, so the
# repository does not need an exported service account key.
resource "google_service_account_iam_member" "github_workload_identity" {
  service_account_id = google_service_account.kb_query_tests.name
  role               = "roles/iam.workloadIdentityUser"
  member             = "principalSet://iam.googleapis.com/projects/808951263862/locations/global/workloadIdentityPools/github/attribute.repository/m-lab/knowledgebase"
}
