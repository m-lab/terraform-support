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
  project = "mlab-sandbox"
  source  = "./platform-cluster"
}

