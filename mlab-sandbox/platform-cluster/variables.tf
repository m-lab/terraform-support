variable "project" {
  default     = "mlab-sandbox"
  description = "GCP project of resources"
  type        = string
}

variable "instances" {
  default = {
    attributes = {
      disk_image   = "platform-cluster-instance-latest"
      disk_size_gb = 100
      disk_type    = "pd-ssd"
      machine_type = "n1-highcpu-4"
      tags         = ["ndt-cloud"]
      scopes       = ["cloud-platform"]
      subnetwork   = "kubernetes"
    },
    names = {
      mlab1-chs0t = "us-east1-c"
      mlab2-chs0t = "us-east1-c"
      mlab1-lax0t = "us-west2-c"
      mlab1-pdx0t = "us-west1-c"
    }
  }
  description = "Platform instances"
  type = object({
    attributes = object({
      disk_image   = string
      disk_size_gb = number
      disk_type    = string
      machine_type = string
      tags         = list(string)
      scopes       = list(string)
      subnetwork   = string
    })
    names = map(string)
  })
}

variable "api_instances" {
  default = {
    machine_attributes = {
      disk_image        = "platform-cluster-api-instance-latest"
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
      cluster_cidr     = "192.168.0.0/16"
      lb_dns           = "api-platform-cluster.mlab-sandbox.measurementlab.net"
      service_cidr     = "172.25.0.0/16"
      token_server_dns = "token-server-platform-cluster.mlab-sandbox.measurementlab.net"
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
  description = "Platform control plane (API) instances"
  type = object({
    machine_attributes = object({
      disk_image         = string
      disk_size_gb_boot  = number
      disk_size_gb_data  = number
      disk_dev_name_data = string
      disk_type          = string
      machine_type       = string
      tags               = list(string)
      region             = string
      scopes             = list(string)
    })
    cluster_attributes = map(string)
    zones              = map(map(string))
  })
}

variable "prometheus_instance" {
  default = {
    disk_image        = "platform-cluster-internal-instance-latest"
    disk_size_gb_boot = 100
    disk_size_gb_data = 200
    disk_type         = "pd-ssd"
    machine_type      = "n2-standard-2"
    tags              = ["prometheus-platform-cluster"]
    region            = "us-west2"
    scopes            = ["cloud-platform"]
    zone              = "us-west2-a"
  }
  description = "Prometheus platform cluster instance"
  type = object({
    disk_image        = string
    disk_size_gb_boot = number
    disk_size_gb_data = number
    disk_type         = string
    machine_type      = string
    tags              = list(string)
    region            = string
    scopes            = list(string)
    zone              = string
  })
}

variable "networking" {
  default = {
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
  description = "Network details for platform instances"
  type = object({
    attributes  = map(string)
    subnetworks = map(map(string))
  })
}
