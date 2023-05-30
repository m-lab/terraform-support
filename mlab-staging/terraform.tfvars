project        = "mlab-staging"
default_region = "us-central1"
default_zone   = "us-central1-a"

instances = {
  attributes = {
    disk_image   = "CHANGEME"
    disk_size_gb = 100
    disk_type    = "pd-ssd"
    machine_type = "n1-highcpu-4"
    network_tier = "PREMIUM"
    tags         = ["ndt-cloud"]
    scopes       = ["cloud-platform"]
  },
  migs = {},
  vms  = {}
}

api_instances = {
  machine_attributes = {
    disk_image        = "CHANGEME"
    disk_size_gb_boot = 100
    disk_size_gb_data = 10
    # This will show up as /dev/disk/by-id/google-<name>
    disk_dev_name_data = "cluster-data"
    disk_type          = "pd-ssd"
    machine_type       = "n1-standard-2"
    tags               = ["platform-cluster"]
    region             = "us-central1"
    scopes             = ["cloud-platform"]
  },
  cluster_attributes = {
    cluster_cidr           = "192.168.0.0/16"
    api_load_balancer      = "api-platform-cluster.mlab-staging.measurementlab.net"
    service_cidr           = "172.25.0.0/16"
    epoxy_extension_server = "epoxy-extension-server.mlab-staging.measurementlab.net"
  },
  zones = {}
}

prometheus_instance = {
  disk_image        = "CHANGEME"
  disk_size_gb_boot = 100
  disk_size_gb_data = 1500
  disk_type         = "pd-ssd"
  machine_type      = "e2-highmem-16"
  tags              = ["prometheus-platform-cluster"]
  region            = "us-central1"
  scopes            = ["cloud-platform"]
  zone              = "us-central1-a"
}

networking = {
  attributes = {
    stack_type      = "IPV4_IPV6"
    subnetwork_cidr = "10.0.0.0/8"
    vpc_name        = "mlab-platform-network"
  }
  subnetworks = {}
}
