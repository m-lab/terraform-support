resource "google_service_account" "autonode" {
  account_id   = "autonode"
  description = "Custom SA for the autonode VM instance (managed by Terraform)"
  display_name = "Autonode VM SA"
}

resource "google_service_account" "gke" {
  account_id   = "autojoin-gke"
  description = "Default SA for the autojoin GKE cluster node pools (managed by Terraform)"
  display_name = "Autojoin GKE SA"
}
