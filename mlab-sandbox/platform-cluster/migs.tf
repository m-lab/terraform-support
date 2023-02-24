resource "google_compute_instance_template" "platform_cluster_mig_templates" {
  for_each = var.instances.names

  description = "Used to create platform cluster virtual machines"

  disk {
    auto_delete  = true
    boot         = true
    source_image = var.instances.attributes.disk_image
    disk_type    = var.instances.attributes.disk_type
    disk_size_gb = var.instances.attributes.disk_size_gb
  }

  lifecycle {
    create_before_destroy = true
  }

  machine_type = var.instances.attributes.machine_type

  metadata = {
    k8s_labels = join(",", [
      "mlab/machine=${split("-", each.key)[0]}",
      "mlab/metro=${substr(each.key, 6, 3)}",
      "mlab/project=${var.project}",
      "mlab/run=ndt",
      "mlab/site=${split("-", each.key)[1]}",
      "mlab/type=virtual"
    ])
    k8s_node = "${each.key}.${var.project}.measurement-lab.org"
  }

  name_prefix = "platform-cluster-mig-template-"

  network_interface {
    network    = google_compute_network.platform_cluster.id
    subnetwork = google_compute_subnetwork.platform_cluster[each.value].id
    stack_type = var.networking.attributes.stack_type
  }

  region = each.value

  scheduling {
    automatic_restart   = true
    on_host_maintenance = "MIGRATE"
  }

  service_account {
    scopes = var.instances.attributes.scopes
  }

  tags = var.instances.attributes.tags
}

resource "google_compute_region_instance_group_manager" "platform_cluster_mig_managers" {
  for_each = var.instances.names

  base_instance_name = "${each.key}-${var.project}-measurement-lab-org"
  name               = "platform-cluster-${each.key}"
  region             = each.value

  update_policy {
    minimal_action = "REFRESH"
    type           = "PROACTIVE"
  }

  version {
    instance_template = google_compute_instance_template.platform_cluster_mig_templates[each.key].id
  }

}

resource "google_compute_region_health_check" "platform_cluster_mig_health_checks" {
  for_each = var.instances.names

  https_health_check {
    port = 443
  }

  name   = "platform-cluster-${each.key}"
  region = each.value
}

resource "google_compute_region_autoscaler" "platform_cluster_mig_autoscalers" {
  for_each = var.instances.names

  autoscaling_policy {
    cooldown_period = 60

    cpu_utilization {
      target = 0.6
    }

    min_replicas = 3
    max_replicas = 9
  }


  name   = "platform-cluster-${each.key}"
  region = each.value
  target = google_compute_region_instance_group_manager.platform_cluster_mig_managers[each.key].id
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

resource "google_compute_address" "platform_cluster_mig_addresses" {
  for_each = var.instances.names

  address_type = "EXTERNAL"
  name         = "platform-cluster-${each.key}"
  region       = each.value
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
