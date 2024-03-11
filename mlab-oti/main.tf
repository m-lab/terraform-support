terraform {
  backend "gcs" {
    # Terraform does not allow variable interpolation in backend blocks.
    bucket = "terraform-support-mlab-oti"
    prefix = "state"
  }
}

provider "google" {
  project = "mlab-oti"
}

provider "google" {
  alias   = "platform-cluster"
  project = "mlab-oti"
  region  = "us-east1"
  zone    = "us-east1-b"
}

provider "google" {
  alias   = "data-pipeline"
  project = "mlab-oti"
  region  = "us-central1"
  zone    = "us-central1-a"
}

provider "google" {
  alias   = "visualizations"
  project = "mlab-oti"
  region  = "us-central1"
  zone    = "us-central1-a"
}

provider "google" {
  alias   = "common"
  project = "mlab-oti"
  region  = "us-central1"
  zone    = "us-central1-a"
}

