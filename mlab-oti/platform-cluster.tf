module "platform-cluster" {
  source = "../modules/platform-cluster"

  providers = {
    google = google.platform-cluster
  }

  instances = {
    attributes = {
      daemonset        = "ndt"
      disk_image       = "platform-cluster-instance-v2-4-6"
      disk_size_gb     = 100
      disk_type        = "pd-ssd"
      machine_type     = "n2-highcpu-4"
      mig_min_replicas = 3
      mig_max_replicas = 15
      network_tier     = "PREMIUM"
      tags             = ["ndt-cloud"]
      scopes           = ["cloud-platform"]
    }
    migs = {}
    vms = {
      mlab1-ams10 = {
        zone = "europe-west4-c"
      },
      mlab1-bom03 = {
        zone = "asia-south1-c"
      },
      mlab2-bom03 = {
        zone = "asia-south1-b"
      },
      mlab3-bom03 = {
        zone = "asia-south1-a"
      },
      mlab1-bru06 = {
        zone = "europe-west1-c"
      },
      mlab1-cgk01 = {
        zone = "asia-southeast2-c"
      },
      mlab2-cgk01 = {
        zone = "asia-southeast2-b"
      },
      mlab3-cgk01 = {
        zone = "asia-southeast2-a"
      },
      mlab1-chs01 = {
        zone = "us-east1-c"
      },
      mlab2-chs01 = {
        network_tier = "STANDARD"
        zone         = "us-east1-b"
      },
      mlab1-cmh01 = {
        zone = "us-east5-c"
      },
      mlab1-del03 = {
        machine_type = "n2-highcpu-8"
        zone         = "asia-south2-c"
      },
      mlab1-dfw09 = {
        zone = "us-south1-c"
      },
      mlab2-dfw09 = {
        zone = "us-south1-b"
      },
      mlab1-fra07 = {
        zone = "europe-west3-c"
      },
      mlab2-fra07 = {
        zone = "europe-west3-b"
      },
      mlab1-gru05 = {
        zone = "southamerica-east1-c"
      },
      mlab2-gru05 = {
        zone = "southamerica-east1-b"
      },
      mlab3-gru05 = {
        zone = "southamerica-east1-a"
      },
      mlab1-hel01 = {
        zone = "europe-north1-c"
      },
      mlab2-hel01 = {
        zone = "europe-north1-b"
      },
      mlab3-hel01 = {
        zone = "europe-north1-a"
      },
      mlab1-hkg04 = {
        zone = "asia-east2-c"
      },
      mlab1-hnd06 = {
        zone = "asia-northeast1-c"
      },
      mlab2-hnd06 = {
        zone = "asia-northeast1-b"
      },
      mlab3-hnd06 = {
        zone = "asia-northeast1-a"
      },
      mlab1-iad07 = {
        zone = "us-east4-c"
      },
      mlab2-iad07 = {
        network_tier = "STANDARD"
        zone         = "us-east4-b"
      },
      mlab1-icn01 = {
        zone = "asia-northeast3-c"
      },
      mlab2-icn01 = {
        zone = "asia-northeast3-b"
      },
      mlab3-icn01 = {
        zone = "asia-northeast3-a"
      },
      mlab1-kix01 = {
        zone = "asia-northeast2-c"
      },
      mlab1-las01 = {
        zone = "us-west4-c"
      },
      mlab1-lax07 = {
        zone = "us-west2-c"
      },
      mlab1-lhr09 = {
        zone = "europe-west2-c"
      },
      mlab1-mad07 = {
        zone = "europe-southwest1-c"
      },
      mlab1-mel01 = {
        zone = "australia-southeast2-c"
      },
      mlab1-mil08 = {
        zone = "europe-west8-c"
      },
      mlab1-oma01 = {
        zone = "us-central1-c"
      },
      mlab1-par08 = {
        zone = "europe-west9-c"
      },
      mlab1-pdx01 = {
        zone = "us-west1-c"
      },
      mlab1-scl05 = {
        zone = "southamerica-west1-c"
      },
      mlab1-sin02 = {
        zone = "asia-southeast1-c"
      },
      mlab1-slc01 = {
        zone = "us-west3-c"
      },
      mlab1-syd07 = {
        zone = "australia-southeast1-c"
      },
      mlab1-tlv01 = {
        zone = "me-west1-c"
      },
      mlab1-tpe02 = {
        zone = "asia-east1-c"
      },
      mlab2-tpe02 = {
        zone = "asia-east1-b"
      },
      mlab1-trn03 = {
        zone = "europe-west12-c"
      },
      mlab1-waw01 = {
        zone = "europe-central2-c"
      },
      mlab2-waw01 = {
        zone = "europe-central2-b"
      },
      mlab3-waw01 = {
        zone = "europe-central2-a"
      },
      mlab1-yul07 = {
        zone = "northamerica-northeast1-c"
      },
      mlab2-yul07 = {
        network_tier = "STANDARD"
        zone         = "northamerica-northeast1-b"
      },
      mlab1-yyz07 = {
        zone = "northamerica-northeast2-c"
      },
      mlab1-zrh01 = {
        zone = "europe-west6-c"
      },
      mlab2-zrh01 = {
        zone = "europe-west6-b"
      },
      mlab3-zrh01 = {
        zone = "europe-west6-a"
      }
    }
  }

  api_instances = {
    machine_attributes = {
      disk_image        = "platform-cluster-api-instance-v2-4-6"
      disk_size_gb_boot = 100
      disk_size_gb_data = 10
      # This will show up as /dev/disk/by-id/google-<name>
      disk_dev_name_data = "cluster-data"
      disk_type          = "pd-ssd"
      machine_type       = "n2-standard-8"
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
    zones = {
      "us-east1-b" = {
        "create_role" = "init",
        "reboot_day"  = "Tue"
      },
      "us-east1-c" = {
        "create_role" = "join",
        "reboot_day"  = "Wed"
      },
      "us-east1-d" = {
        "create_role" = "join",
        "reboot_day"  = "Thu"
      }
    }
  }

  prometheus_instance = {
    disk_image        = "platform-cluster-internal-instance-v2-4-6"
    disk_size_gb_boot = 100
    disk_size_gb_data = 3500
    disk_type         = "pd-ssd"
    machine_type      = "n2-highmem-32"
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
    subnetworks = {
      "asia-east1" = {
        ip_cidr_range = "10.9.0.0/16"
        name          = "kubernetes"
        region        = "asia-east1"
      },
      "asia-east2" = {
        ip_cidr_range = "10.18.0.0/16"
        name          = "kubernetes"
        region        = "asia-east2"
      },
      "asia-northeast1" = {
        ip_cidr_range = "10.31.0.0/16"
        name          = "kubernetes"
        region        = "asia-northeast1"
      },
      "asia-northeast2" = {
        ip_cidr_range = "10.22.0.0/16"
        name          = "kubernetes"
        region        = "asia-northeast2"
      },
      "asia-northeast3" = {
        ip_cidr_range = "10.29.0.0/16"
        name          = "kubernetes"
        region        = "asia-northeast3"
      },
      "asia-south1" = {
        ip_cidr_range = "10.24.0.0/16"
        name          = "kubernetes"
        region        = "asia-south1"
      },
      "asia-south2" = {
        ip_cidr_range = "10.16.0.0/16"
        name          = "kubernetes"
        region        = "asia-south2"
      },
      "asia-southeast1" = {
        ip_cidr_range = "10.11.0.0/16"
        name          = "kubernetes"
        region        = "asia-southeast1"
      },
      "asia-southeast2" = {
        ip_cidr_range = "10.10.0.0/16"
        name          = "kubernetes"
        region        = "asia-southeast2"
      },
      "australia-southeast1" = {
        ip_cidr_range = "10.30.0.0/16"
        name          = "kubernetes"
        region        = "australia-southeast1"
      },
      "australia-southeast2" = {
        ip_cidr_range = "10.20.0.0/16"
        name          = "kubernetes"
        region        = "australia-southeast2"
      },
      "europe-central2" = {
        ip_cidr_range = "10.33.0.0/16"
        name          = "kubernetes"
        region        = "europe-central2"
      },
      "europe-north1" = {
        ip_cidr_range = "10.17.0.0/16"
        name          = "kubernetes"
        region        = "europe-north1"
      },
      "europe-southwest1" = {
        ip_cidr_range = "10.19.0.0/16"
        name          = "kubernetes"
        region        = "europe-southwest1"
      },
      "europe-west1" = {
        ip_cidr_range = "10.6.0.0/16"
        name          = "kubernetes"
        region        = "europe-west1"
      },
      "europe-west2" = {
        ip_cidr_range = "10.7.0.0/16"
        name          = "kubernetes"
        region        = "europe-west2"
      },
      "europe-west3" = {
        ip_cidr_range = "10.8.0.0/16"
        name          = "kubernetes"
        region        = "europe-west3"
      },
      "europe-west4" = {
        ip_cidr_range = "10.13.0.0/16"
        name          = "kubernetes"
        region        = "europe-west4"
      },
      "europe-west6" = {
        ip_cidr_range = "10.34.0.0/16"
        name          = "kubernetes"
        region        = "europe-west6"
      },
      "europe-west8" = {
        ip_cidr_range = "10.21.0.0/16"
        name          = "kubernetes"
        region        = "europe-west8"
      },
      "europe-west9" = {
        ip_cidr_range = "10.25.0.0/16"
        name          = "kubernetes"
        region        = "europe-west9"
      },
      "europe-west12" = {
        ip_cidr_range = "10.37.0.0/16"
        name          = "kubernetes"
        region        = "europe-west12"
      },
      "me-west1" = {
        ip_cidr_range = "10.35.0.0/16"
        name          = "kubernetes"
        region        = "me-west1"
      },
      "northamerica-northeast1" = {
        ip_cidr_range = "10.23.0.0/16"
        name          = "kubernetes"
        region        = "northamerica-northeast1"
      }
      "northamerica-northeast2" = {
        ip_cidr_range = "10.32.0.0/16"
        name          = "kubernetes"
        region        = "northamerica-northeast2"
      },
      "southamerica-east1" = {
        ip_cidr_range = "10.28.0.0/16",
        name          = "kubernetes"
        region        = "southamerica-east1"
      },
      "southamerica-west1" = {
        ip_cidr_range = "10.27.0.0/16"
        name          = "kubernetes"
        region        = "southamerica-west1"
      },
      "us-central1" = {
        ip_cidr_range = "10.3.0.0/16"
        name          = "kubernetes"
        region        = "us-central1"
      },
      "us-east1" = {
        ip_cidr_range = "10.0.0.0/16"
        name          = "kubernetes"
        region        = "us-east1"
      },
      "us-east4" = {
        ip_cidr_range = "10.2.0.0/16"
        name          = "kubernetes"
        region        = "us-east4"
      },
      "us-east5" = {
        ip_cidr_range = "10.14.0.0/16"
        name          = "kubernetes"
        region        = "us-east5"
      },
      "us-south1" = {
        ip_cidr_range = "10.15.0.0/16"
        name          = "kubernetes"
        region        = "us-south1"
      },
      "us-west1" = {
        ip_cidr_range = "10.4.0.0/16"
        name          = "kubernetes"
        region        = "us-west1"
      }
      "us-west2" = {
        ip_cidr_range = "10.5.0.0/16"
        name          = "kubernetes"
        region        = "us-west2"
      },
      "us-west3" = {
        ip_cidr_range = "10.26.0.0/16"
        name          = "kubernetes"
        region        = "us-west3"
      },
      "us-west4" = {
        ip_cidr_range = "10.12.0.0/16"
        name          = "kubernetes"
        region        = "us-west4"
      }
    }
  }

}
