terraform {
  backend "gcs" {
    # Terraform does not allow variable interpolation in backend blocks.
    bucket = "terraform-support-mlab-sandbox"
    prefix = "state"
  }
}

provider "google" {
  project = "mlab-sandbox"
}

provider "google" {
  alias   = "platform-cluster"
  project = "mlab-sandbox"
  region  = "us-west2"
  zone    = "us-west2-a"
}

provider "google" {
  alias   = "data-pipeline"
  project = "mlab-sandbox"
  region  = "us-central1"
  zone    = "us-central1-a"
}

provider "google" {
  alias   = "visualizations"
  project = "mlab-sandbox"
  region  = "us-central1"
  zone    = "us-central1-a"
}

provider "google" {
  alias   = "common"
  project = "mlab-sandbox"
  region  = "us-central1"
  zone    = "us-central1-a"
}
