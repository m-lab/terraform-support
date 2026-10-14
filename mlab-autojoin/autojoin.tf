module "autojoin" {
  source = "../modules/autojoin"

  providers = {
    google = google.autojoin
  }

  autonode_zone = "us-central1-a"
}
