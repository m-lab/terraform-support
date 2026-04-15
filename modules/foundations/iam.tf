resource "google_project_iam_custom_role" "orgadm_operator" {
  description = "Permissions to run orgadm for BYOS onboarding (service accounts, secrets, DNS, IAM)"
  permissions = [
    "dns.changes.create",
    "dns.managedZones.create",
    "dns.managedZones.get",
    "dns.resourceRecordSets.get",
    "iam.serviceAccountKeys.create",
    "iam.serviceAccounts.create",
    "iam.serviceAccounts.get",
    "resourcemanager.projects.getIamPolicy",
    "resourcemanager.projects.setIamPolicy",
    "secretmanager.secrets.create",
    "secretmanager.secrets.get",
    "secretmanager.versions.access",
    "secretmanager.versions.add",
  ]
  role_id = "orgadm_operator"
  stage   = "GA"
  title   = "orgadm-operator"
}

resource "google_project_iam_custom_role" "orgadm_credentials" {
  description = "Permissions to manage orgadm platform credentials in Datastore"
  permissions = [
    "appengine.applications.get",
    "databasesconsole.locations.get",
    "databasesconsole.locations.list",
    "datastore.databases.get",
    "datastore.databases.getMetadata",
    "datastore.databases.list",
    "datastore.entities.allocateIds",
    "datastore.entities.create",
    "datastore.entities.get",
    "datastore.entities.list",
    "datastore.entities.update",
    "datastore.namespaces.get",
    "datastore.namespaces.list",
    "datastore.schemas.list",
    "datastore.statistics.get",
    "datastore.statistics.list",
    "resourcemanager.projects.get",
  ]
  role_id = "orgadm_credentials"
  stage   = "GA"
  title   = "orgadm-credentials"
}
