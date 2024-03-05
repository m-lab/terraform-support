terraform {
  backend "gcs" {
    # Terraform does not allow variable interpolation in backend blocks.
    bucket = "terraform-support-mlab-autojoin"
    prefix = "state"
  }
}

provider "google" {
  project = "mlab-autojoin"
}

provider "google" {
  alias   = "data-pipeline"
  project = "mlab-autojoin"
  region  = "us-central1"
  zone    = "us-central1-a"
}

provider "google" {
  alias   = "platform-cluster"
  project = "mlab-autojoin"
  region  = "us-central1"
  zone    = "us-central1-a"
}

provider "google" {
  alias   = "visualizations"
  project = "mlab-autojoin"
  region  = "us-central1"
  zone    = "us-central1-a"
}
