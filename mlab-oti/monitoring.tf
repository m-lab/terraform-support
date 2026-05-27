module "monitoring" {
  source = "../modules/monitoring"

  providers = {
    google = google.monitoring
  }

  region      = "us-central1"
  zone        = "us-central1-a"
  subnet_cidr = "10.41.0.0/16"
}

