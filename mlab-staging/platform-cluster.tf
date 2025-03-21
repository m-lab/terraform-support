module "platform-cluster" {
  source = "../modules/platform-cluster"

  providers = {
    google = google.platform-cluster
  }

  instances = {
    attributes = {
      daemonset        = "ndt"
      disk_image       = "platform-cluster-instance-2025-02-26t16-53-00"
      disk_size_gb     = 100
      disk_type        = "pd-ssd"
      machine_type     = "n2-highcpu-4"
      mig_min_replicas = 1
      mig_max_replicas = 3
      network_tier     = "PREMIUM"
      probability      = 1.0
      tags             = ["ndt-cloud"]
      scopes           = ["cloud-platform"]
    },
    migs = {
      mlab4-dfw13 = {
        region       = "us-south1"
        loadbalanced = true
      }
    },
    vms = {
      mlab3-iad08 = {
        zone = "us-east4-c"
      },
      mlab4-iad08 = {
        zone = "us-east4-c"
      },
      mlab4-lax08 = {
        zone = "us-west2-c"
      }
    }
  }

  api_instances = {
    machine_attributes = {
      disk_image        = "platform-cluster-api-instance-2025-02-26t16-53-00"
      disk_size_gb_boot = 100
      disk_size_gb_data = 10
      # This will show up as /dev/disk/by-id/google-<name>
      disk_dev_name_data = "cluster-data"
      disk_type          = "pd-ssd"
      machine_type       = "n2-standard-4"
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
    zones = {
      "us-central1-a" = {
        "create_role" = "init",
        "reboot_day"  = "Tue"
      },
      "us-central1-b" = {
        "create_role" = "join",
        "reboot_day"  = "Wed"
      },
      "us-central1-c" = {
        "create_role" = "join",
        "reboot_day"  = "Thu"
      }
    }
  }

  prometheus_instance = {
    disk_image        = "platform-cluster-internal-instance-2025-02-26t16-53-00"
    disk_size_gb_boot = 100
    disk_size_gb_data = 1500
    disk_type         = "pd-ssd"
    machine_type      = "n2-highmem-16"
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
    subnetworks = {
      "us-central1" = {
        ip_cidr_range = "10.0.0.0/16"
        name          = "kubernetes"
        region        = "us-central1"
      },
      "us-east4" = {
        ip_cidr_range = "10.2.0.0/16"
        name          = "kubernetes"
        region        = "us-east4"
      },
      "us-west2" = {
        ip_cidr_range = "10.3.0.0/16"
        name          = "kubernetes"
        region        = "us-west2"
      },
      "us-south1" = {
        ip_cidr_range = "10.4.0.0/16"
        name          = "kubernetes"
        region        = "us-south1"
      }
    }
  }

}
