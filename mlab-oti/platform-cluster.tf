module "platform-cluster" {
  source = "../modules/platform-cluster"

  providers = {
    google = google.platform-cluster
  }

  instances = {
    attributes = {
      daemonset        = "ndt"
      disk_image       = "platform-cluster-instance-v2-4-20"
      disk_size_gb     = 100
      disk_type        = "pd-ssd"
      machine_type     = "n2-highcpu-4"
      mig_min_replicas = 1
      mig_max_replicas = 5
      network_tier     = "PREMIUM"
      tags             = ["ndt-cloud"]
      scopes           = ["cloud-platform"]
    }
    migs = {
      mlab1-ams11 = {
        region = "europe-west4"
      },
      mlab1-ber02 = {
        # We cannot currently get any N2 quota in this region.
        machine_type = "e2-highcpu-4"
        region       = "europe-west10"
      },
      mlab1-bom06 = {
        region = "asia-south1"
      },
      mlab1-bru07 = {
        region = "europe-west1"
      },
      mlab1-cgk02 = {
        region = "asia-southeast2"
      },
      mlab1-chs02 = {
        region = "us-east1"
      },
      mlab1-cmh02 = {
        region = "us-east5"
      },
      mlab1-del05 = {
        region = "asia-south2"
      },
      mlab1-dfw12 = {
        region = "us-south1"
      },
      mlab1-doh02 = {
        # This region is new and we can't currently get any N2 quota.
        machine_type = "e2-highcpu-4"
        region       = "me-central1"
      },
      mlab1-fra08 = {
        region = "europe-west3"
      },
      mlab1-gru06 = {
        region = "southamerica-east1"
      },
      mlab1-hel02 = {
        region = "europe-north1"
      },
      mlab1-hkg05 = {
        region = "asia-east2"
      },
      mlab1-hnd07 = {
        region = "asia-northeast1"
      },
      mlab1-iad09 = {
        region = "us-east4"
      },
      mlab1-icn02 = {
        region = "asia-northeast3"
      },
      mlab1-jnb02 = {
        # This region is new and we can't currently get any N2 quota.
        machine_type = "e2-highcpu-4"
        region       = "africa-south1"
      },
      mlab1-kix02 = {
        region = "asia-northeast2"
      },
      mlab1-las02 = {
        region = "us-west4"
      },
      mlab1-lax10 = {
        region = "us-west2"
      },
      mlab1-lhr10 = {
        region = "europe-west2"
      },
      mlab1-mad08 = {
        region = "europe-southwest1"
      },
      mlab1-mel02 = {
        region = "australia-southeast2"
      },
      mlab1-mil09 = {
        region = "europe-west8"
      },
      mlab1-oma02 = {
        region = "us-central1"
      },
      mlab1-par09 = {
        region = "europe-west9"
      },
      mlab1-pdx03 = {
        region = "us-west1"
      },
      mlab1-scl06 = {
        region = "southamerica-west1"
      },
      mlab1-sin03 = {
        region = "asia-southeast1"
      },
      mlab1-slc02 = {
        region = "us-west3"
      },
      mlab1-syd08 = {
        region = "australia-southeast1"
      },
      mlab1-tlv02 = {
        region = "me-west1"
      },
      mlab1-tpe03 = {
        region = "asia-east1"
      },
      mlab1-trn04 = {
        region = "europe-west12"
      },
      mlab1-waw02 = {
        region = "europe-central2"
      },
      mlab1-yul08 = {
        region = "northamerica-northeast1"
      },
      mlab1-yyz08 = {
        region = "northamerica-northeast2"
      }
      mlab1-zrh02 = {
        region = "europe-west6"
      }
    }
    vms = {
      mlab1-ams10 = {
        zone = "europe-west4-c"
      },
      mlab1-ber01 = {
        # We cannot currently get any N2 quota in this region.
        machine_type = "e2-highcpu-4"
        zone         = "europe-west10-c"
      },
      mlab1-bom05 = {
        zone = "asia-south1-c"
      },
      mlab2-bom05 = {
        zone = "asia-south1-b"
      },
      mlab3-bom05 = {
        zone = "asia-south1-a"
      },
      mlab1-bru06 = {
        zone = "europe-west1-c"
      },
      mlab1-cmh01 = {
        zone = "us-east5-c"
      },
      mlab1-fra07 = {
        zone = "europe-west3-c"
      },
      mlab2-fra07 = {
        zone = "europe-west3-b"
      },
      mlab1-hkg04 = {
        zone = "asia-east2-c"
      },
      mlab1-kix01 = {
        zone = "asia-northeast2-c"
      },
      mlab1-las01 = {
        zone = "us-west4-c"
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
      mlab1-sin02 = {
        zone = "asia-southeast1-c"
      },
      mlab1-slc01 = {
        zone = "us-west3-c"
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
      mlab1-yyz07 = {
        zone = "northamerica-northeast2-c"
      }
    }
  }

  api_instances = {
    machine_attributes = {
      disk_image        = "platform-cluster-api-instance-v2-4-20"
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
    disk_image        = "platform-cluster-internal-instance-v2-4-20"
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
    # This is not ideal, but when a new region is added, in order to find the
    # next CIDR range not in use for the subnetwork, you can do something like
    # the following:
    #
    # grep ip_cidr_range mlab-oti/platform-cluster.tf | sort --version-sort
    subnetworks = {
      "africa-south1" = {
        ip_cidr_range = "10.40.0.0/16"
        name          = "kubernetes"
        region        = "africa-south1"
      },
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
      "europe-west10" = {
        ip_cidr_range = "10.38.0.0/16"
        name          = "kubernetes"
        region        = "europe-west10"
      },
      "europe-west12" = {
        ip_cidr_range = "10.37.0.0/16"
        name          = "kubernetes"
        region        = "europe-west12"
      },
      "me-central1" = {
        ip_cidr_range = "10.39.0.0/16"
        name          = "kubernetes"
        region        = "me-central1"
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
