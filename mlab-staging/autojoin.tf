module "autojoin" {
  source = "../modules/autojoin"

  providers = {
    google = google.autojoin
  }

  # Test VM for the mlab-node Debian package (byos-debian).
  deploy_autonode_deb = true
}
