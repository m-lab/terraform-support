terraform {
  backend "gcs" {
    # Terraform does not allow variable interpolation in backend blocks.
    bucket = "terraform-support-mlab-staging"
    prefix = "state"
  }
}

provider "google" {
  project = "mlab-staging"
}

provider "google" {
  alias   = "platform-cluster"
  project = "mlab-staging"
  region  = "us-central1"
  zone    = "us-central1-a"
}

provider "google" {
  alias   = "data-pipeline"
  project = "mlab-staging"
  region  = "us-central1"
  zone    = "us-central1-a"
}

provider "google" {
  alias   = "visualizations"
  project = "mlab-staging"
  region  = "us-central1"
  zone    = "us-central1-a"
}

provider "google" {
  alias   = "foundations"
  project = "mlab-staging"
  region  = "us-central1"
  zone    = "us-central1-a"
}

provider "google" {
  alias   = "autojoin"
  project = "mlab-staging"
  region  = "us-central1"
  zone    = "us-central1-c"
}

provider "google" {
  alias   = "google-oim"
  project = "mlab-staging"
  region  = "us-central1"
  zone    = "us-central1-c"
}

