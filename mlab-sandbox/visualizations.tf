module "visualizations" {
  source = "../modules/visualizations"

  providers = {
    google = google.visualizations
  }
}
