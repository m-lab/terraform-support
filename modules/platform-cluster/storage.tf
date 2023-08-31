resource "google_storage_bucket" "k8s_support_mlab_sandbox" {
  name          = "k8s-support-${data.google_client_config.current.project}"
  location      = "US"
  storage_class = "MULTI_REGIONAL"
}
