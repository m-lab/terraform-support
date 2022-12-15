terraform {
  backend "gcs" {
    bucket = "terraform-support-mlab-sandbox"
    prefix = "state"
  }
}

provider "google" {
  project = "mlab-sandbox"
  region  = "us-central1"
  zone    = "us-central1-c"
}

module "platform-cluster" {
  project = "mlab-sandbox"
  source  = "./platform-cluster"
}
