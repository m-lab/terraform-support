project        = "mlab-oti"
default_region = "us-east1"
default_zone   = "us-east1-b"

instances = {
  attributes = {
    disk_image   = "CHANGEME"
    disk_size_gb = 100
    disk_type    = "pd-ssd"
    machine_type = "n1-highcpu-4"
    network_tier = "PREMIUM"
    tags         = ["ndt-cloud"]
    scopes       = ["cloud-platform"]
  }
  migs = {}
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
    region             = "us-east1"
    scopes             = ["cloud-platform"]
  }
  cluster_attributes = {
    cluster_cidr           = "192.168.0.0/16"
    api_load_balancer      = "api-platform-cluster.mlab-oti.measurementlab.net"
    service_cidr           = "172.25.0.0/16"
    epoxy_extension_server = "epoxy-extension-server.mlab-oti.measurementlab.net"
  }
  zones = {}
}

prometheus_instance = {
  disk_image        = "CHANGEME"
  disk_size_gb_boot = 100
  disk_size_gb_data = 3500
  disk_type         = "pd-ssd"
  machine_type      = "e2-highmem-32"
  tags              = ["prometheus-platform-cluster"]
  region            = "us-east1"
  scopes            = ["cloud-platform"]
  zone              = "us-east1-b"
}

networking = {
  attributes = {
    stack_type      = "IPV4_IPV6"
    subnetwork_cidr = "10.0.0.0/8"
    vpc_name        = "mlab-platform-network"
  }
  subnetworks = {}
}
