resource "google_service_account" "service" {
  account_id   = var.name
  description  = "Runtime SA for the ${var.name} automation Cloud Run service (managed by Terraform)"
  display_name = "${var.name} automation SA"
}
