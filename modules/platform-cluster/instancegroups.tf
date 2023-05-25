#
# Managed instance groups for regular platform VMs
#
resource "google_compute_instance_template" "platform_cluster_mig_templates" {
  for_each = var.instances.migs

  description = "Platform cluster MIG machine"

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
    access_config {
      # If the MIG specifies a network_tier, use it, else use a default.
      network_tier = lookup(each.value, "network_tier", var.instances.attributes.network_tier)
    }

    ipv6_access_config {
      # From what I gather STANDARD network tier is not available for IPv6.
      # https://cloud.google.com/network-tiers/docs/overview#resources
      network_tier = "PREMIUM"
    }

    network    = google_compute_network.platform_cluster.id
    subnetwork = google_compute_subnetwork.platform_cluster[each.value["region"]].id
    stack_type = var.networking.attributes.stack_type
  }

  region = each.value["region"]

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
  for_each = var.instances.migs

  base_instance_name = "${each.key}-${var.project}-measurement-lab-org"
  name               = "${each.key}-${var.project}-measurement-lab-org"
  region             = each.value["region"]

  update_policy {
    max_surge_fixed = length(var.instances.migs)
    minimal_action  = "REPLACE"
    type            = "PROACTIVE"
  }

  version {
    instance_template = google_compute_instance_template.platform_cluster_mig_templates[each.key].id
  }

}

resource "google_compute_region_autoscaler" "platform_cluster_mig_autoscalers" {
  for_each = var.instances.migs

  autoscaling_policy {
    cooldown_period = 60

    cpu_utilization {
      target = 0.6
    }

    min_replicas = 3
    max_replicas = 9
  }

  name   = "${each.key}-${var.project}-measurement-lab-org"
  region = each.value["region"]
  target = google_compute_region_instance_group_manager.platform_cluster_mig_managers[each.key].id
}


#
# Unmanaged instance group for the control plane machines
#
resource "google_compute_instance_group" "platform_cluster" {
  for_each = var.api_instances.zones

  name    = "api-platform-cluster-${each.key}"
  network = google_compute_network.platform_cluster.id
  zone    = each.key

  # Instances will add themselves to this group when the cluster is initialized.
  # Not doing this here rather than on the machine itself is due to an
  # undesirable behavior of GCP load balancers (at least external TCP ones).
  # Backend machines of a load balancer cannot communicate normally with the
  # load balancer itself, and requests to the load balancer IP are reflected
  # back to the backend machine making the request, whether its health check is
  # passing or not. This means that when a machine is trying to join the cluster
  # and needs to communicate with the existing cluster to get configuration
  # data, it is actually trying to communicate with itself, but it is not yet
  # created so gets a connection refused error.
  #instances = [
  #  google_compute_instance.api_instances[each.key].id
  #]

  # https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/compute_instance_group
  lifecycle {
    create_before_destroy = true
  }
}
