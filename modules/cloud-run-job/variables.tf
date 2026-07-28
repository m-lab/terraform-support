variable "name" {
  description = "Automation name. Must match its directory in the source repository; also used for the service account, secrets prefix, trigger, and Scheduler job."
  type        = string
}

variable "region" {
  description = "Region for the Cloud Run service and Scheduler job."
  type        = string
  default     = "us-east1"
}

variable "schedule" {
  description = "Cron schedule for the Scheduler job."
  type        = string
}

variable "time_zone" {
  description = "Time zone for the Scheduler job."
  type        = string
  default     = "UTC"
}

variable "attempt_deadline" {
  description = "How long Scheduler waits for the :run API call. The call returns as soon as the execution is created, so this does not need to cover the job's runtime."
  type        = string
  default     = "180s"
}

variable "project_roles" {
  description = "Project-level roles granted to the automation's service account, e.g. [\"roles/bigquery.jobUser\"]."
  type        = list(string)
  default     = []
}

variable "secrets" {
  description = "Short names of Secret Manager secrets to create for this automation. Each becomes <name>-<short name>; values are added out of band."
  type        = list(string)
  default     = []
}

variable "github_owner" {
  description = "GitHub owner of the source repository."
  type        = string
  default     = "m-lab"
}

variable "github_repo" {
  description = "GitHub source repository holding the automation directories."
  type        = string
  default     = "automations"
}

variable "trigger_branch" {
  description = "Branch regex for the Cloud Build trigger. Set exactly one of trigger_branch and trigger_tag."
  type        = string
  default     = null
}

variable "trigger_tag" {
  description = "Tag regex for the Cloud Build trigger. Set exactly one of trigger_branch and trigger_tag."
  type        = string
  default     = null
}

variable "build_substitutions" {
  description = "Substitution variables passed to the Cloud Build trigger."
  type        = map(string)
  default     = {}
}
