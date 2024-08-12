resource "google_service_account" "autonode" {
  account_id   = "autonode"
  display_name = "Custom SA for the autonode VM instance (managed by Terraform)"
}
