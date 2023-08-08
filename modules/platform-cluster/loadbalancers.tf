#
# Managed instance group load balancers for regular platfrom VMs
#
resource "google_compute_address" "platform_cluster_mig_addresses" {
  for_each = var.instances.migs

  address_type = "EXTERNAL"
  name         = "${each.key}-${var.project}-measurement-lab-org"
  region       = each.value["region"]
}

resource "google_compute_region_health_check" "platform_cluster_mig_health_checks" {
  for_each = var.instances.migs

  https_health_check {
    port = 443
  }

  name   = "${each.key}-${var.project}-measurement-lab-org"
  region = each.value["region"]
}

resource "google_compute_region_backend_service" "platform_cluster_mig_backends" {
  for_each = var.instances.migs

  backend {
    group = google_compute_region_instance_group_manager.platform_cluster_mig_managers[each.key].instance_group
  }

  name                  = "${each.key}-${var.project}-measurement-lab-org"
  health_checks         = [google_compute_region_health_check.platform_cluster_mig_health_checks[each.key].id]
  load_balancing_scheme = "EXTERNAL"
  protocol              = "UNSPECIFIED"
  region                = each.value["region"]
  session_affinity      = "CLIENT_IP"
}

resource "google_compute_forwarding_rule" "platform_cluster_mig_forwarding_rules" {
  for_each = var.instances.migs

  all_ports             = true
  backend_service       = google_compute_region_backend_service.platform_cluster_mig_backends[each.key].id
  ip_address            = google_compute_address.platform_cluster_mig_addresses[each.key].id
  ip_protocol           = "L3_DEFAULT"
  load_balancing_scheme = "EXTERNAL"
  name                  = "${each.key}-${var.project}-measurement-lab-org"
  region                = each.value["region"]
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
# Internal load balancer for the ePoxy extension server. The
# extension server service runs on each of the control plane nodes.
#
resource "google_compute_address" "epoxy_extension_server" {
  address_type = "INTERNAL"
  name         = "epoxy-extension-server"
  region       = var.api_instances.machine_attributes.region
  subnetwork   = google_compute_subnetwork.platform_cluster["${var.api_instances.machine_attributes.region}"].id
}

resource "google_compute_health_check" "epoxy_extension_server" {
  tcp_health_check {
    port               = "8800"
    port_specification = "USE_FIXED_PORT"
  }

  name = "epoxy-extension-server"
}

resource "google_compute_region_backend_service" "epoxy_extension_server" {
  dynamic "backend" {
    for_each = google_compute_instance_group.platform_cluster
    content {
      group = backend.value.id
    }
  }
  health_checks         = [google_compute_health_check.epoxy_extension_server.id]
  load_balancing_scheme = "INTERNAL"
  name                  = "epoxy-extension-server"
  protocol              = "TCP"
  region                = var.api_instances.machine_attributes.region
}

resource "google_compute_forwarding_rule" "epoxy_extension_server" {
  allow_global_access   = true
  backend_service       = google_compute_region_backend_service.epoxy_extension_server.id
  ip_address            = google_compute_address.epoxy_extension_server.id
  load_balancing_scheme = "INTERNAL"
  name                  = "epoxy-extension-server"
  network               = google_compute_network.platform_cluster.id
  ports                 = ["8800"]
  region                = var.api_instances.machine_attributes.region
  subnetwork            = google_compute_subnetwork.platform_cluster["${var.api_instances.machine_attributes.region}"].id
}
