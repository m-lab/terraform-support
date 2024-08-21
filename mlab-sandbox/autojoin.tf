module "autojoin" {
  source = "../modules/autojoin"

  providers = {
    google = google.autojoin
  }

  # On sandbox, GAE was initially set up to be on us-east1, and this cannot
  # be easily changed, se we override the appengine_region here.
  appengine_region = "us-east1"
}
