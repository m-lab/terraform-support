module "common" {
  source = "../modules/common"

  providers = {
    google = google.common
  }
}

