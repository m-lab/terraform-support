module "autojoin" {
  source = "../modules/autojoin"

  providers = {
    google = google.autojoin
  }

  # Test VM for the mlab-node Debian package (byos-debian). Not in
  # us-central1-c (the provider default) because that zone was out of
  # n2-standard-2 capacity at creation time.
  deploy_autonode_deb = true
  autonode_deb_zone   = "us-central1-a"
}
