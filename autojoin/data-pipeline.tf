module "data-pipeline" {
  source = "../modules/data-pipeline"

  providers = {
    google = google.data-pipeline
  }
}
