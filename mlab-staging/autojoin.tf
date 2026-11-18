module "autojoin" {
  source = "../modules/autojoin"

  providers = {
    google = google.autojoin
  }

  autonode_machine_type = "e2-standard-2"

  # Test VM for the mlab-node Debian package (byos-debian). Not in
  # us-central1-c (the provider default) because that zone was out of
  # n2-standard-2 capacity at creation time.
  deploy_autonode_deb = true
  autonode_deb_zone   = "us-central1-a"

  # Workload identity federation: the token-exchange instance whose storage
  # tokens the pool trusts.
  wif_issuer = "https://auth.mlab-staging.measurementlab.net"
}
