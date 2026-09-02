module "autojoin" {
  source = "../modules/autojoin"

  providers = {
    google = google.autojoin
  }

  # On sandbox, GAE was initially set up to be on us-east1, and this cannot
  # be easily changed, se we override the appengine_region here.
  appengine_region = "us-east1"

  # Test VM for the mlab-node Debian package (byos-debian). e2 rather than the
  # autonode VM's n2: every us-central1 zone was out of n2/n2d capacity at
  # creation time. Drop the override to go back to n2-standard-2.
  deploy_autonode_deb       = true
  autonode_deb_machine_type = "e2-standard-2"
  autonode_deb_zone         = "us-central1-c"
}
