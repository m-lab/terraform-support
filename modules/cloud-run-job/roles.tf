resource "google_project_iam_member" "service_roles" {
  for_each = toset(var.project_roles)

  project = data.google_project.current.project_id
  role    = each.value
  member  = "serviceAccount:${google_service_account.service.email}"
}

# The Scheduler job authenticates as the automation's own service account,
# which needs run.invoker (run.jobs.run) to start executions. Granted at the
# project level because the Cloud Run job itself is created by Cloud Build on
# first deploy, so it does not yet exist when this wiring is applied.
resource "google_project_iam_member" "service_run_invoker" {
  project = data.google_project.current.project_id
  role    = "roles/run.invoker"
  member  = "serviceAccount:${google_service_account.service.email}"
}
