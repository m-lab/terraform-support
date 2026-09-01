# APT repository for the mlab-node Debian package (github.com/m-lab/byos-debian).
# The autojoin module is instantiated in mlab-sandbox, mlab-staging and
# mlab-autojoin, which are also the package's channel tiers: byos-debian's CI
# publishes dev snapshots (pushes to main) to the sandbox repository and
# releases (v* tags) to staging and production. Every repository is private;
# grant roles/artifactregistry.reader to allUsers to open one up.
resource "google_artifact_registry_repository" "mlab_node" {
  location      = "us-central1"
  repository_id = "mlab-node"
  description   = "mlab-node Debian package (dev snapshots in sandbox, releases in staging/production)"
  format        = "APT"
}

# byos-debian's GitHub Actions publish through the shared "github" Workload
# Identity Pool in mlab-testing, bound directly to the repository (no service
# account to manage or key to export).
resource "google_artifact_registry_repository_iam_member" "mlab_node_github_writer" {
  location   = google_artifact_registry_repository.mlab_node.location
  repository = google_artifact_registry_repository.mlab_node.name
  role       = "roles/artifactregistry.writer"
  member     = "principalSet://iam.googleapis.com/projects/808951263862/locations/global/workloadIdentityPools/github/attribute.repository/m-lab/byos-debian"
}

# The autonode VMs install and upgrade mlab-node from this repository through
# apt-transport-artifact-registry, which authenticates as the VM's service
# account.
resource "google_artifact_registry_repository_iam_member" "mlab_node_autonode_reader" {
  location   = google_artifact_registry_repository.mlab_node.location
  repository = google_artifact_registry_repository.mlab_node.name
  role       = "roles/artifactregistry.reader"
  member     = "serviceAccount:${google_service_account.autonode.email}"
}
