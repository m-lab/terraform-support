terraform {
  backend "gcs" {
    # Terraform does not allow variable interpolation in backend blocks.
    bucket = "terraform-support-oim-vms"
    prefix = "state"
  }
}

provider "google" {
  project = "mlab-sandbox"
}

provider "google" {
  alias   = "google-oim"
  project = "mlab-sandbox"
  region  = "us-east1"
  zone    = "us-east1-b"
}
