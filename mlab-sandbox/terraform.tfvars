project        = "mlab-sandbox"
default_region = "us-west2"
default_zone   = "us-west2-a"

instances = {
  attributes = {
    disk_image       = "platform-cluster-instance-2023-07-28t17-41-18"
    disk_size_gb     = 100
    disk_type        = "pd-ssd"
    machine_type     = "n2-highcpu-4"
    mig_min_replicas = 1
    mig_max_replicas = 5
    network_tier     = "PREMIUM"
    tags             = ["ndt-cloud"]
    scopes           = ["cloud-platform"]
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
    disk_image        = "platform-cluster-api-instance-2023-08-01t16-27-12"
    disk_size_gb_boot = 100
    disk_size_gb_data = 10
    # This will show up as /dev/disk/by-id/google-<name>
    disk_dev_name_data = "cluster-data"
    disk_type          = "pd-ssd"
    machine_type       = "n2-standard-2"
    tags               = ["platform-cluster"]
    region             = "us-west2"
    scopes             = ["cloud-platform"]
  }
  cluster_attributes = {
    api_load_balancer      = "api-platform-cluster.mlab-sandbox.measurementlab.net"
    cluster_cidr           = "192.168.0.0/16"
    epoxy_extension_server = "epoxy-extension-server.mlab-sandbox.measurementlab.net"
    service_cidr           = "172.25.0.0/16"
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
  disk_image        = "platform-cluster-internal-instance-2023-07-28t17-41-18"
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
      ip_cidr_range = "10.4.0.0/16"
      name          = "kubernetes"
      region        = "us-east1"
    }
  }
}

ssh_keys = [
  {
    user   = "nkinkade"
    pubkey = "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQDcmNS78HLR2Q/22if7mT8yoICDQbk+wbHJqDAWWGui/V7HrzDZn9X2KtyxLPu6sdD3oohmZWYSQ9JVnIT/XQCCKrYiQt5Q/Jof4MG/evJnQEgNcmF6Cb6cFcG7dichGRiWqlNMwMG7GuvDXAsNQ/unrZFfeQTPHpKkDJkspcwxKH0+9fLgerLsJRlcAsyCb1AWtG8pwD2yKyispWhVCDKU1RbEfohxSj9tUcJJewXaiMGfn5T/t3dCLAx3zv3YrAtETAmRqfRwdztKevwqVTXU78rr9HRBwD2+YC0T0mdVUljeGhU3UzQlxSa4ZeIu1FimpyAv7jz1hu/hliQkl8BN nkinkade@npk"
  },
  {
    user   = "roberto"
    pubkey = "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQDhnC8VDQyHUHBsmwTmprMSrPQ3qkuFyemkNO1OBSWEyhVRPdp7M+tvCY0QqbKhnMY0ImEV/g8+zubnA1TAI4JQVbfDStEi5TBGONRyUk/B10sV9uNRGFqmBJZmEE6XcsHvWuBgX4icWCz+XPXnqWHqyTUY4YGkPAeKVjQD9zZjK581hFUKowrSZC9SUagJ160h0zcG1O4n14EkKlwDfYp4DDbYHI5QF+KTjr6xwbK5IZDr4K2GzvcKq8SHj+g5zaWhuBB8ruqvgBwqOF7ZNvXfTH45hUjL+BY0e6IZUPv7kW0yFzcvBiPmBpkPYCtY0SDd8wFPKjYyYshfeuTNE+eN roberto@measurementlab.net"
  },
  {
    user   = "soltesz"
    pubkey = "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQDR5EylJIM/ZF9mSUwOSlysILS/rPfi/y6EvO19oOR+LrGmeATKFfFePKZrRD5TufNaGubxG1CeYUQ7ib50qYtivjfcf0eFJZtN3oEopLwbtihwD87Bv2jJX1YgRAMQ7Fh9FcwtOL4CdpCZ/VHe+EG32G2S9krn2SW1GifJWc/gBpb4S21igtpuQJoHAU/sxxxzEZWUm2BCUvoIQoCcwOqoor5DPB8hM4Jz0rM6uDO30EUO8YVjHr9cz8j8MA0WbLGjk7xfuIrx7SqHgoairC9s0N4AafHaKYzbvG/lz336wgpGC6gktAkHljUHnerwESF7ABTIh8iwKiq27HhO0hOt soltesz@stephens-imac-4.lan"
  }
]
