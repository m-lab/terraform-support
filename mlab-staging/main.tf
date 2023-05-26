terraform {
  backend "gcs" {
    # Terraform does not allow variable interpolation in backend blocks.
    bucket = "terraform-support-mlab-staging"
    prefix = "state"
  }
}

provider "google" {
  project = var.project
  region  = var.default_region
  zone    = var.default_zone
}

module "platform-cluster" {
  source = "../modules/platform-cluster"

  project             = var.project
  default_region      = var.default_region
  default_zone        = var.default_zone
  instances           = var.instances
  api_instances       = var.api_instances
  prometheus_instance = var.prometheus_instance
  networking          = var.networking
}
