provider "google" {
  project = "mlab-sandbox"
}


module "data-pipeline-cluster-us-central1" {
  source = "./data-pipeline"
}
