# Wiring for services in the m-lab/automations repository. One
# cloud-run-job instantiation per automation: runtime service account,
# IAM, secret shells, deploy trigger, and schedule.

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
  # ndt-upgrade-sync/cloudbuild.yaml. TODO(roberto): fill with the sandbox
  # test list before the first deploy.
  build_substitutions = {
    _CLICKUP_LIST_ID   = ""
    _CF_ORG_NAME       = ""
    _CF_UPGRADE_STATUS = ""
  }
}
