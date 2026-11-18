module "autojoin" {
  source = "../modules/autojoin"

  providers = {
    google = google.autojoin
  }

  autonode_machine_type = "e2-standard-2"
  autonode_zone         = "us-central1-a"

  # Workload identity federation: the token-exchange instance whose storage
  # tokens the pool trusts.
  # In production token-exchange runs in mlab-oti, not in this project.
  wif_issuer = "https://auth.mlab-oti.measurementlab.net"
}
