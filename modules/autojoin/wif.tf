# Workload Identity Federation for node credentials. Nodes present a JWT issued
# by token-exchange, which Google STS exchanges through this pool. Per-org
# write access is granted on GCS managed folders by orgadm, outside of
# Terraform. Read access is the pool-wide bindings below.

data "google_project" "current" {}

locals {
  wif_pool_members = "principalSet://iam.googleapis.com/projects/${data.google_project.current.number}/locations/global/workloadIdentityPools/${google_iam_workload_identity_pool.autojoin.workload_identity_pool_id}/*"
}

resource "google_iam_workload_identity_pool" "autojoin" {
  workload_identity_pool_id = "autojoin"
  display_name              = "autojoin"
  description               = "Autojoin node credentials issued by token-exchange"
}

resource "google_iam_workload_identity_pool_provider" "token_exchange" {
  workload_identity_pool_id          = google_iam_workload_identity_pool.autojoin.workload_identity_pool_id
  workload_identity_pool_provider_id = "token-exchange"
  display_name                       = "token-exchange"

  attribute_mapping = {
    "google.subject" = "assertion.sub"
    "attribute.org"  = "assertion.org"
  }

  oidc {
    # No uploaded keys: Google reads the signing keys from the JWKS that the
    # issuer advertises at /.well-known/openid-configuration.
    issuer_uri        = var.wif_issuer
    allowed_audiences = ["storage"]
  }
}

resource "google_storage_bucket_iam_member" "autojoin_wif_archive_viewer" {
  bucket = "archive-${data.google_client_config.current.project}"
  role   = "roles/storage.objectViewer"
  member = local.wif_pool_members
}

resource "google_storage_bucket_iam_member" "autojoin_wif_downloader_viewer" {
  bucket = "downloader-${data.google_client_config.current.project}"
  role   = "roles/storage.objectViewer"
  member = local.wif_pool_members
}
