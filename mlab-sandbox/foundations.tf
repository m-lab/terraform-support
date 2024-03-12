module "foundations" {
  source = "../modules/foundations"

  providers = {
    google = google.foundations
  }
}

