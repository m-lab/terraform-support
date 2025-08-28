terraform {
  backend "gcs" {
    # Terraform does not allow variable interpolation in backend blocks.
    bucket = "terraform-support-measurement-lab"
    prefix = "state"
  }
}

provider "google" {
  project = "measurement-lab"
}

provider "google" {
  alias   = "platform-cluster"
  project = "measurement-lab"
  region  = "us-central1"
  zone    = "us-central1-a"
}

provider "google" {
  alias   = "data-pipeline"
  project = "measurement-lab"
  region  = "us-central1"
  zone    = "us-central1-a"
}

provider "google" {
  alias   = "visualizations"
  project = "measurement-lab"
  region  = "us-central1"
  zone    = "us-central1-a"
}

provider "google" {
  alias   = "foundations"
  project = "measurement-lab"
  region  = "us-central1"
  zone    = "us-central1-a"
}

provider "google" {
  alias   = "google-oim"
  project = "measurement-lab"
  region  = "us-central1"
  zone    = "us-central1-a"
}

