resource "google_storage_bucket" "k8s_support_mlab_sandbox" {
  name          = "k8s-support-mlab-sandbox"
  location      = "US"
  storage_class = "MULTI_REGIONAL"
}
