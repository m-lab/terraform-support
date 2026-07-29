# Wiring for services in the m-lab/automations repository. One
# cloud-run-job instantiation per automation: runtime service account,
# IAM, secret shells, deploy trigger, and schedule.

data "google_project" "current" {}

# The default Cloud Build SA runs this repository's applies and needs to
# manage the secrets and log-based metrics created for automations. Its
# other roles are currently granted out of band; these are recorded here.
resource "google_project_iam_member" "cloudbuild_secretmanager_admin" {
  project = data.google_project.current.project_id
  role    = "roles/secretmanager.admin"
  member  = "serviceAccount:${data.google_project.current.number}@cloudbuild.gserviceaccount.com"
}

resource "google_project_iam_member" "cloudbuild_logging_config_writer" {
  project = data.google_project.current.project_id
  role    = "roles/logging.configWriter"
  member  = "serviceAccount:${data.google_project.current.number}@cloudbuild.gserviceaccount.com"
}

# Shared log-based metrics for all automations in this project. They reach
# the federation Prometheus through the stackdriver exporter, which already
# pulls the logging.googleapis.com/user metric prefix; generic alert rules
# in m-lab/prometheus-support consume them, grouped by job name.
resource "google_logging_metric" "automations_job_errors" {
  name = "automations_job_errors"
  # Counts logError() lines from the automations plus anything a crashing
  # container writes to stderr. Not covered: infra-level kills that log only
  # at WARNING severity (e.g. OOM), which would need execution-level checks.
  filter = "resource.type=\"cloud_run_job\" AND severity>=ERROR"

  metric_descriptor {
    metric_kind = "DELTA"
    value_type  = "INT64"
  }
}

resource "google_logging_metric" "automations_scheduler_errors" {
  name   = "automations_scheduler_errors"
  filter = "resource.type=\"cloud_scheduler_job\" AND severity>=ERROR"

  metric_descriptor {
    metric_kind = "DELTA"
    value_type  = "INT64"
  }
}

module "ndt-upgrade-sync" {
  source = "../modules/cloud-run-job"

  name     = "ndt-upgrade-sync"
  schedule = "0 6 * * *"

  # Runs read-only queries against the public measurement-lab datasets,
  # billed to this project.
  project_roles = ["roles/bigquery.jobUser"]

  secrets = ["clickup-token"]

  # Sandbox tracks sandbox-* branches.
  trigger_branch = "^sandbox-.*$"

  # ClickUp list and custom field ids, consumed by the deploy step in
  # ndt-upgrade-sync/cloudbuild.yaml. These point at the "NDT Upgrade Sync
  # [sandbox test]" list; the production wiring will use the real list.
  build_substitutions = {
    _CLICKUP_LIST_ID   = "901418580143"
    _CF_ORG_NAME       = "b0d1de2c-cfac-4402-8481-5f8396e472e9"
    _CF_UPGRADE_STATUS = "af917b24-305e-4f31-a722-00f0ded4f96a"
  }
}
