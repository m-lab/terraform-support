#
# Control plane load balancer, and related resources
#
resource "google_compute_address" "platform_cluster_lb" {
  address_type = "EXTERNAL"
  name         = "platform-cluster-lb"
  region       = var.control_plane_region
}

resource "google_compute_region_health_check" "platform_cluster" {
  https_health_check {
    port               = "6443"
    port_specification = "USE_FIXED_PORT"
    request_path       = "/healthz"
  }

  name   = "platform-cluster"
  region = var.control_plane_region
}

resource "google_compute_region_backend_service" "platform_cluster" {
  dynamic "backend" {
    for_each = google_compute_instance_group.platform_cluster
    content {
      group = backend.value.id
    }
  }
  health_checks         = [google_compute_region_health_check.platform_cluster.id]
  load_balancing_scheme = "EXTERNAL"
  name                  = "platform-cluster"
  protocol              = "TCP"
  region                = var.control_plane_region
}

resource "google_compute_forwarding_rule" "platform_cluster" {
  backend_service = google_compute_region_backend_service.platform_cluster.id
  ip_address      = google_compute_address.platform_cluster_lb.id
  name            = "platform-cluster"
  ports           = ["6443"]
  region          = var.control_plane_region
}

resource "google_compute_instance_group" "platform_cluster" {
  for_each = {
    for z in var.control_plane_zones : z => {
      zone = "${var.control_plane_region}-${z}"
    }
  }
  name = "master-platform-cluster-${each.value.zone}"
  zone = each.value.zone
  # TODO (kinkade): once control plane nodes are managed by terraform, change
  # this static resource ID to a terraform resource reference.
  instances = [
    "projects/${var.project}/zones/${each.value.zone}/instances/master-platform-cluster-${each.value.zone}"
  ]
}

#
# Internal load balancer for ePoxy extension "allocate_k8s_token". The
# token_server service runs on each of the control plane nodes.
#
resource "google_compute_address" "token_server_lb" {
  address_type = "INTERNAL"
  name         = "token-server-lb"
  region       = var.control_plane_region
  subnetwork   = google_compute_subnetwork.kubernetes["us-west2"].id
}

resource "google_compute_health_check" "token_server" {
  tcp_health_check {
    port               = "8800"
    port_specification = "USE_FIXED_PORT"
  }

  name = "token-server"
}

resource "google_compute_region_backend_service" "token_server" {
  dynamic "backend" {
    for_each = google_compute_instance_group.platform_cluster
    content {
      group = backend.value.id
    }
  }
  health_checks         = [google_compute_health_check.token_server.id]
  load_balancing_scheme = "INTERNAL"
  name                  = "token-server"
  protocol              = "TCP"
  region                = var.control_plane_region
}

resource "google_compute_forwarding_rule" "token_server" {
  backend_service       = google_compute_region_backend_service.token_server.id
  ip_address            = google_compute_address.token_server_lb.id
  load_balancing_scheme = "INTERNAL"
  name                  = "token-server"
  network               = google_compute_network.mlab_platform_network.id
  ports                 = ["8800"]
  region                = var.control_plane_region
  subnetwork            = google_compute_subnetwork.kubernetes["us-west2"].id
}

#
# Internal load balancer for ePoxy extension "bmc_store_password". The
# bmc_store_password service runs on each of the control plane nodes.
#
resource "google_compute_address" "bmc_store_password_lb" {
  address_type = "INTERNAL"
  name         = "bmc-store-password-lb"
  region       = var.control_plane_region
  subnetwork   = google_compute_subnetwork.kubernetes["us-west2"].id
}

resource "google_compute_health_check" "bmc_store_password" {
  tcp_health_check {
    port               = "8801"
    port_specification = "USE_FIXED_PORT"
  }

  name = "bmc-store-password"
}

resource "google_compute_region_backend_service" "bmc_store_password" {
  dynamic "backend" {
    for_each = google_compute_instance_group.platform_cluster
    content {
      group = backend.value.id
    }
  }
  health_checks         = [google_compute_health_check.bmc_store_password.id]
  load_balancing_scheme = "INTERNAL"
  name                  = "bmc-store-password"
  protocol              = "TCP"
  region                = var.control_plane_region
}

resource "google_compute_forwarding_rule" "bmc_store_password" {
  backend_service       = google_compute_region_backend_service.bmc_store_password.id
  ip_address            = google_compute_address.bmc_store_password_lb.id
  load_balancing_scheme = "INTERNAL"
  name                  = "bmc-store-password"
  network               = google_compute_network.mlab_platform_network.id
  ports                 = ["8801"]
  region                = var.control_plane_region
  subnetwork            = google_compute_subnetwork.kubernetes["us-west2"].id
}
