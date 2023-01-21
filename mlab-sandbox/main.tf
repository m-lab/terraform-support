terraform {
  backend "gcs" {
    bucket = "terraform-support-mlab-sandbox"
    prefix = "kinkade-test-state"
  }
}

provider "google" {
  project = "mlab-sandbox"
  region  = "us-central1"
  zone    = "us-central1-c"
}

/*
module "platform-cluster" {
  project = "mlab-sandbox"
  source  = "./platform-cluster"
}
*/

module "control-plane" {
  project = "mlab-sandbox"
  source  = "./control-plane"
}
