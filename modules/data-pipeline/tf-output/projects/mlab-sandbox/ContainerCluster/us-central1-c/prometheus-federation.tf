resource "google_container_cluster" "prometheus_federation" {
  addons_config {
    gce_persistent_disk_csi_driver_config {
      enabled = true
    }

    network_policy_config {
      disabled = true
    }
  }

  cluster_autoscaling {
    enabled             = false
  }

  cluster_ipv4_cidr = "10.48.0.0/14"

  #cluster_telemetry {
  #  type = "ENABLED"
  #}

  description        = "Global Prometheus cluster for mlab-sandbox"
  enable_legacy_abac = true
  location           = "us-central1-c"

  logging_config {
    enable_components = ["SYSTEM_COMPONENTS", "WORKLOADS"]
  }

  master_auth {
    client_certificate_config {
      issue_client_certificate = true
    }
  }

  monitoring_config {
    enable_components = ["SYSTEM_COMPONENTS"]
  }

  name    = "prometheus-federation"
  network = "projects/mlab-sandbox/global/networks/default"

  network_policy {
    enabled  = false
    provider = "PROVIDER_UNSPECIFIED"
  }

  networking_mode = "ROUTES"

  node_config {
    disk_size_gb = 100
    disk_type    = "pd-standard"
    image_type   = "COS_CONTAINERD"
    machine_type = "n2-standard-4"

    metadata = {
      disable-legacy-endpoints = "true"
    }

    oauth_scopes    = ["https://www.googleapis.com/auth/cloud-platform"]
    service_account = "default"

    shielded_instance_config {
      enable_integrity_monitoring = true
    }
  }

  node_version = "1.25.10-gke.1200"

  #pod_security_policy_config {
  #  enabled = false
  #}

  private_cluster_config {
    enable_private_endpoint = false

    master_global_access_config {
      enabled = false
    }
  }

  project = "mlab-sandbox"

  release_channel {
    channel = "STABLE"
  }

  subnetwork = "projects/mlab-sandbox/regions/us-central1/subnetworks/default"
}
# terraform import google_container_cluster.prometheus_federation mlab-sandbox/us-central1-c/prometheus-federation
