module "google_oim" {
  source = "../modules/google-oim"

  providers = {
    google = google.google-oim
  }

  instances = {
    attributes = {
      disk_image   = "google-oim-instance-2025-08-27t17-33-25"
      disk_size_gb = 100
      disk_type    = "pd-ssd"
      machine_type = "e2-highcpu-4"
      probability  = 1.0
      tags         = []
    }
    vms = {
      mlab1-chs03 = {
        zone = "us-east1-d"
      },
    }
  }

  networking = {
    attributes = {
      stack_type      = "IPV4_ONLY"
      subnetwork_cidr = "10.0.0.0/8"
      vpc_name        = "mlab-network"
    }
    # This is not ideal, but when a new region is added, in order to find the
    # next CIDR range not in use for the subnetwork, you can do something like
    # the following:
    #
    # grep ip_cidr_range google-oim/google-oim.tf | sort --version-sort
    subnetworks = {
      "africa-south1" = {
        ip_cidr_range = "10.40.0.0/16"
        name          = "mlab"
        region        = "africa-south1"
      },
      "asia-east1" = {
        ip_cidr_range = "10.9.0.0/16"
        name          = "mlab"
        region        = "asia-east1"
      },
      "asia-east2" = {
        ip_cidr_range = "10.18.0.0/16"
        name          = "mlab"
        region        = "asia-east2"
      },
      "asia-northeast1" = {
        ip_cidr_range = "10.31.0.0/16"
        name          = "mlab"
        region        = "asia-northeast1"
      },
      "asia-northeast2" = {
        ip_cidr_range = "10.22.0.0/16"
        name          = "mlab"
        region        = "asia-northeast2"
      },
      "asia-northeast3" = {
        ip_cidr_range = "10.29.0.0/16"
        name          = "mlab"
        region        = "asia-northeast3"
      },
      "asia-south1" = {
        ip_cidr_range = "10.24.0.0/16"
        name          = "mlab"
        region        = "asia-south1"
      },
      "asia-south2" = {
        ip_cidr_range = "10.16.0.0/16"
        name          = "mlab"
        region        = "asia-south2"
      },
      "asia-southeast1" = {
        ip_cidr_range = "10.11.0.0/16"
        name          = "mlab"
        region        = "asia-southeast1"
      },
      "asia-southeast2" = {
        ip_cidr_range = "10.10.0.0/16"
        name          = "mlab"
        region        = "asia-southeast2"
      },
      "australia-southeast1" = {
        ip_cidr_range = "10.30.0.0/16"
        name          = "mlab"
        region        = "australia-southeast1"
      },
      "australia-southeast2" = {
        ip_cidr_range = "10.20.0.0/16"
        name          = "mlab"
        region        = "australia-southeast2"
      },
      "europe-central2" = {
        ip_cidr_range = "10.33.0.0/16"
        name          = "mlab"
        region        = "europe-central2"
      },
      "europe-north1" = {
        ip_cidr_range = "10.17.0.0/16"
        name          = "mlab"
        region        = "europe-north1"
      },
      "europe-southwest1" = {
        ip_cidr_range = "10.19.0.0/16"
        name          = "mlab"
        region        = "europe-southwest1"
      },
      "europe-west1" = {
        ip_cidr_range = "10.6.0.0/16"
        name          = "mlab"
        region        = "europe-west1"
      },
      "europe-west2" = {
        ip_cidr_range = "10.7.0.0/16"
        name          = "mlab"
        region        = "europe-west2"
      },
      "europe-west3" = {
        ip_cidr_range = "10.8.0.0/16"
        name          = "mlab"
        region        = "europe-west3"
      },
      "europe-west4" = {
        ip_cidr_range = "10.13.0.0/16"
        name          = "mlab"
        region        = "europe-west4"
      },
      "europe-west6" = {
        ip_cidr_range = "10.34.0.0/16"
        name          = "mlab"
        region        = "europe-west6"
      },
      "europe-west8" = {
        ip_cidr_range = "10.21.0.0/16"
        name          = "mlab"
        region        = "europe-west8"
      },
      "europe-west9" = {
        ip_cidr_range = "10.25.0.0/16"
        name          = "mlab"
        region        = "europe-west9"
      },
      "europe-west10" = {
        ip_cidr_range = "10.38.0.0/16"
        name          = "mlab"
        region        = "europe-west10"
      },
      "europe-west12" = {
        ip_cidr_range = "10.37.0.0/16"
        name          = "mlab"
        region        = "europe-west12"
      },
      "me-central1" = {
        ip_cidr_range = "10.39.0.0/16"
        name          = "mlab"
        region        = "me-central1"
      },
      "me-west1" = {
        ip_cidr_range = "10.35.0.0/16"
        name          = "mlab"
        region        = "me-west1"
      },
      "northamerica-northeast1" = {
        ip_cidr_range = "10.23.0.0/16"
        name          = "mlab"
        region        = "northamerica-northeast1"
      }
      "northamerica-northeast2" = {
        ip_cidr_range = "10.32.0.0/16"
        name          = "mlab"
        region        = "northamerica-northeast2"
      },
      "southamerica-east1" = {
        ip_cidr_range = "10.28.0.0/16",
        name          = "mlab"
        region        = "southamerica-east1"
      },
      "southamerica-west1" = {
        ip_cidr_range = "10.27.0.0/16"
        name          = "mlab"
        region        = "southamerica-west1"
      },
      "us-central1" = {
        ip_cidr_range = "10.3.0.0/16"
        name          = "mlab"
        region        = "us-central1"
      },
      "us-east1" = {
        ip_cidr_range = "10.0.0.0/16"
        name          = "mlab"
        region        = "us-east1"
      },
      "us-east4" = {
        ip_cidr_range = "10.2.0.0/16"
        name          = "mlab"
        region        = "us-east4"
      },
      "us-east5" = {
        ip_cidr_range = "10.14.0.0/16"
        name          = "mlab"
        region        = "us-east5"
      },
      "us-south1" = {
        ip_cidr_range = "10.15.0.0/16"
        name          = "mlab"
        region        = "us-south1"
      },
      "us-west1" = {
        ip_cidr_range = "10.4.0.0/16"
        name          = "mlab"
        region        = "us-west1"
      }
      "us-west2" = {
        ip_cidr_range = "10.5.0.0/16"
        name          = "mlab"
        region        = "us-west2"
      },
      "us-west3" = {
        ip_cidr_range = "10.26.0.0/16"
        name          = "mlab"
        region        = "us-west3"
      },
      "us-west4" = {
        ip_cidr_range = "10.12.0.0/16"
        name          = "mlab"
        region        = "us-west4"
      }
    }
  }

}
