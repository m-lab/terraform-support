module "monitoring" {
  source = "../modules/monitoring"

  providers = {
    google = google.monitoring
  }

  region      = "us-central1"
  zone        = "us-central1-c"
  subnet_cidr = "10.5.0.0/16"
}
