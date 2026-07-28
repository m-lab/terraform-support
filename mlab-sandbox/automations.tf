# Wiring for services in the m-lab/automations repository. One
# cloud-run-job instantiation per automation: runtime service account,
# IAM, secret shells, deploy trigger, and schedule.

data "google_project" "current" {}

# The default Cloud Build SA runs this repository's applies and needs to
# manage the secrets created by the cloud-run-job module. Its other roles
# are currently granted out of band; this one is recorded here.
resource "google_project_iam_member" "cloudbuild_secretmanager_admin" {
  project = data.google_project.current.project_id
  role    = "roles/secretmanager.admin"
  member  = "serviceAccount:${data.google_project.current.number}@cloudbuild.gserviceaccount.com"
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
