#
# Managed instance group load balancers for regular platfrom VMs
#
resource "google_compute_address" "platform_cluster_mig_addresses" {
  for_each = var.instances.names

  address_type = "EXTERNAL"
  name         = "platform-cluster-${each.key}"
  region       = each.value
}

resource "google_compute_region_health_check" "platform_cluster_mig_health_checks" {
  for_each = var.instances.names

  https_health_check {
    port = 443
  }

  name   = "platform-cluster-${each.key}"
  region = each.value
}

resource "google_compute_region_backend_service" "platform_cluster_mig_backends" {
  for_each = var.instances.names

  backend {
    group = google_compute_region_instance_group_manager.platform_cluster_mig_managers[each.key].instance_group
  }

  name                  = "platform-cluster-${each.key}"
  health_checks         = [google_compute_region_health_check.platform_cluster_mig_health_checks[each.key].id]
  load_balancing_scheme = "EXTERNAL"
  protocol              = "UNSPECIFIED"
  region                = each.value
  session_affinity      = "CLIENT_IP"
}

resource "google_compute_forwarding_rule" "platform_cluster_mig_forwarding_rules" {
  for_each = var.instances.names

  all_ports             = true
  backend_service       = google_compute_region_backend_service.platform_cluster_mig_backends[each.key].id
  ip_address            = google_compute_address.platform_cluster_mig_addresses[each.key].id
  ip_protocol           = "L3_DEFAULT"
  load_balancing_scheme = "EXTERNAL"
  name                  = "platform-cluster-${each.key}"
  region                = each.value
}


#
# API load balancer
#
resource "google_compute_address" "platform_cluster_lb" {
  address_type = "EXTERNAL"
  name         = "platform-cluster-lb"
  region       = var.api_instances.machine_attributes.region
}

resource "google_compute_region_health_check" "platform_cluster" {
  https_health_check {
    port               = "6443"
    port_specification = "USE_FIXED_PORT"
    request_path       = "/readyz"
  }

  name   = "platform-cluster"
  region = var.api_instances.machine_attributes.region
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
  region                = var.api_instances.machine_attributes.region
}

resource "google_compute_forwarding_rule" "platform_cluster" {
  backend_service = google_compute_region_backend_service.platform_cluster.id
  ip_address      = google_compute_address.platform_cluster_lb.id
  name            = "platform-cluster"
  ports           = ["6443"]
  region          = var.api_instances.machine_attributes.region
}


#
# Internal load balancer for ePoxy extension "allocate_k8s_token". The
# token_server service runs on each of the control plane nodes.
#
resource "google_compute_address" "token_server_lb" {
  address_type = "INTERNAL"
  name         = "token-server-lb"
  region       = var.api_instances.machine_attributes.region
  subnetwork   = google_compute_subnetwork.platform_cluster["${var.api_instances.machine_attributes.region}"].id
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
  region                = var.api_instances.machine_attributes.region
}

resource "google_compute_forwarding_rule" "token_server" {
  allow_global_access   = true
  backend_service       = google_compute_region_backend_service.token_server.id
  ip_address            = google_compute_address.token_server_lb.id
  load_balancing_scheme = "INTERNAL"
  name                  = "token-server"
  network               = google_compute_network.platform_cluster.id
  ports                 = ["8800"]
  region                = var.api_instances.machine_attributes.region
  subnetwork            = google_compute_subnetwork.platform_cluster["${var.api_instances.machine_attributes.region}"].id
}

#
# Internal load balancer for ePoxy extension "bmc_store_password". The
# bmc_store_password service runs on each of the control plane nodes.
#
resource "google_compute_address" "bmc_store_password_lb" {
  address_type = "INTERNAL"
  name         = "bmc-store-password-lb"
  region       = var.api_instances.machine_attributes.region
  subnetwork   = google_compute_subnetwork.platform_cluster["${var.api_instances.machine_attributes.region}"].id
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
  region                = var.api_instances.machine_attributes.region
}

resource "google_compute_forwarding_rule" "bmc_store_password" {
  backend_service       = google_compute_region_backend_service.bmc_store_password.id
  ip_address            = google_compute_address.bmc_store_password_lb.id
  load_balancing_scheme = "INTERNAL"
  name                  = "bmc-store-password"
  network               = google_compute_network.platform_cluster.id
  ports                 = ["8801"]
  region                = var.api_instances.machine_attributes.region
  subnetwork            = google_compute_subnetwork.platform_cluster["${var.api_instances.machine_attributes.region}"].id
}
