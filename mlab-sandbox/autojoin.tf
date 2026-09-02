module "autojoin" {
  source = "../modules/autojoin"

  providers = {
    google = google.autojoin
  }

  # On sandbox, GAE was initially set up to be on us-east1, and this cannot
  # be easily changed, se we override the appengine_region here.
  appengine_region = "us-east1"

  # Test VM for the mlab-node Debian package (byos-debian). Not in
  # us-central1-c (the provider default) or us-central1-a: both were out of
  # n2-standard-2 capacity at creation time.
  deploy_autonode_deb = true
  autonode_deb_zone   = "us-central1-b"
}
