provider "google" {
  project = var.project
  region = var.default_region
}


module "data-pipeline-cluster-us-central1" {
  source = "./data-pipeline"

  project = "mlab-sandbox"
  default_region = "us-central1"
  default_location = "us-central1"
}
