project        = "mlab-sandbox"
default_region = "us-west2"
default_zone   = "us-west2-a"

instances = {
  attributes = {
    disk_image   = "platform-cluster-instance-2023-05-12t17-52-24"
    disk_size_gb = 100
    disk_type    = "pd-ssd"
    machine_type = "n1-highcpu-4"
    network_tier = "PREMIUM"
    tags         = ["ndt-cloud"]
    scopes       = ["cloud-platform"]
  },
  migs = {
    mlab1-chs0t = {
      region = "us-east1"
    },
    mlab1-lax0t = {
      region = "us-west2"
    },
    mlab1-pdx0t = {
      region = "us-west1"
    }
  },
  vms = {
    mlab2-chs0t = {
      zone = "us-east1-c"
    }
  }
}

api_instances = {
  machine_attributes = {
    disk_image        = "platform-cluster-api-instance-2023-05-12t17-52-24"
    disk_size_gb_boot = 100
    disk_size_gb_data = 10
    # This will show up as /dev/disk/by-id/google-<name>
    disk_dev_name_data = "cluster-data"
    disk_type          = "pd-ssd"
    machine_type       = "n1-standard-2"
    tags               = ["platform-cluster"]
    region             = "us-west2"
    scopes             = ["cloud-platform"]
  }
  cluster_attributes = {
    cluster_cidr           = "192.168.0.0/16"
    api_load_balancer      = "api-platform-cluster.mlab-sandbox.measurementlab.net"
    service_cidr           = "172.25.0.0/16"
    epoxy_extension_server = "epoxy-extension-server.mlab-sandbox.measurementlab.net"
  }
  zones = {
    "us-west2-a" = {
      "create_role" = "init",
      "reboot_day"  = "Tue"
    },
    "us-west2-b" = {
      "create_role" = "join",
      "reboot_day"  = "Wed"
    },
    "us-west2-c" = {
      "create_role" = "join",
      "reboot_day"  = "Thu"
    }
  }
}

prometheus_instance = {
  disk_image        = "platform-cluster-internal-instance-2023-05-12t17-52-24"
  disk_size_gb_boot = 100
  disk_size_gb_data = 200
  disk_type         = "pd-ssd"
  machine_type      = "n2-standard-2"
  tags              = ["prometheus-platform-cluster"]
  region            = "us-west2"
  scopes            = ["cloud-platform"]
  zone              = "us-west2-a"
}

networking = {
  attributes = {
    stack_type      = "IPV4_IPV6"
    subnetwork_cidr = "10.0.0.0/8"
    vpc_name        = "mlab-platform-network"
  }
  subnetworks = {
    "us-west2" = {
      ip_cidr_range = "10.0.0.0/16"
      name          = "kubernetes"
      region        = "us-west2"
    },
    "us-west1" = {
      ip_cidr_range = "10.2.0.0/16"
      name          = "kubernetes"
      region        = "us-west1"
    },
    "us-east1" = {
      name          = "kubernetes"
      ip_cidr_range = "10.4.0.0/16"
      region        = "us-east1"
    }
  }
}
