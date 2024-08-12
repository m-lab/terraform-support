module "autojoin" {
  source = "../modules/autojoin"

  providers = {
    google = google.autojoin
  }
}
