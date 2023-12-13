resource "google_compute_network" "data_pipeline" {
  auto_create_subnetworks = false
  description             = "Communication between backend processing services, e.g. etl, gardener, autoloader, or stats pipelines."
  name                    = "data-pipeline"
  routing_mode            = "REGIONAL"
}

resource "google_compute_subnetwork" "data_pipeline" {
  name          = "pipeline"
  ip_cidr_range = "10.80.0.0/16"
  network       = google_compute_network.data_pipeline.id
  region        = data.google_client_config.current.region
}

resource "google_compute_address" "data_pipeline" {
  name         = "data-pipeline-ingress-nginx"
  address_type = "EXTERNAL"
  description  = "External IP address for ingress-nginx"
}
