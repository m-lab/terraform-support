terraform {
  backend "gcs" {
    # Terraform does not allow variable interpolation in backend blocks.
    bucket = "terraform-support-mlab-sandbox"
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
  default_location    = var.default_location
  instances           = var.instances
  api_instances       = var.api_instances
  prometheus_instance = var.prometheus_instance
  networking          = var.networking
  ssh_keys            = var.ssh_keys
}

module "data-pipeline" {
  source = "../modules/data-pipeline"

  project = var.project
  default_region = var.default_location
  default_location = var.default_location
}
