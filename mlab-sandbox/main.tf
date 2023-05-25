terraform {
  backend "gcs" {
    bucket = "terraform-support-mlab-sandbox"
    prefix = "state"
  }
}

provider "google" {
  project = "mlab-sandbox"
  region  = "us-west2"
  zone    = "us-west2-a"
}

module "platform-cluster" {
  source = "../modules/platform-cluster"

  project             = var.project
  instances           = var.instances
  api_instances       = var.api_instances
  prometheus_instance = var.prometheus_instance
  networking          = var.networking
}
