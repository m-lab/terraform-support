module "autojoin" {
  source = "../modules/autojoin"

  providers = {
    google = google.autojoin
  }

  autonode_machine_type = "e2-standard-2"
  autonode_zone         = "us-central1-a"
}
