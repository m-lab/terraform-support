# Wiring for one automation from the m-lab/automations repository: deploy
# trigger and schedule. The Cloud Run job itself is created and updated by
# Cloud Build (see <name>/cloudbuild.yaml in the source repository).
#
# The GitHub repository must be connected to Cloud Build in this project
# (Cloud Build GitHub app) before the trigger can be created.
resource "google_cloudbuild_trigger" "deploy" {
  name           = var.name
  description    = "Deploy the ${var.name} automation on matching pushes (managed by Terraform)"
  filename       = "${var.name}/cloudbuild.yaml"
  included_files = ["${var.name}/**"]
  substitutions  = var.build_substitutions

  github {
    owner = var.github_owner
    name  = var.github_repo

    push {
      branch = var.trigger_branch
      tag    = var.trigger_tag
    }
  }
}

resource "google_cloud_scheduler_job" "job" {
  name             = var.name
  description      = "Runs the ${var.name} automation (managed by Terraform)"
  region           = var.region
  schedule         = var.schedule
  time_zone        = var.time_zone
  attempt_deadline = var.attempt_deadline

  http_target {
    http_method = "POST"
    # Starts an execution of the Cloud Run job via the Admin API. The call
    # returns as soon as the execution is created; the job's own task timeout
    # bounds the actual run.
    uri = "https://run.googleapis.com/v2/projects/${data.google_project.current.project_id}/locations/${var.region}/jobs/${var.name}:run"

    oauth_token {
      service_account_email = google_service_account.service.email
      scope                 = "https://www.googleapis.com/auth/cloud-platform"
    }
  }
}
