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
      machine_type = "n2-highcpu-4"
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
    attributes = {
      disk_image   = "platform-cluster-api-instance-latest"
      disk_size_gb = "100"
      disk_type    = "pd-ssd"
      machine_type = "n2-standard-2"
      tags         = ["platform-cluster"]
      region       = "us-west2"
      scopes       = ["cloud-platform"]
      subnetwork   = "kubernetes"
    }
    zones = ["us-west2-a", "us-west2-b", "us-west2-c"]
  }
  description = "Platform control plane (API) instances"
  type = object({
    attributes = object({
      disk_image   = string
      disk_size_gb = number
      disk_type    = string
      machine_type = string
      tags         = list(string)
      region       = string
      scopes       = list(string)
      subnetwork   = string
    })
    zones = list(string)
  })
}

variable "networking" {
  default = {
    attributes = {
      vpc_name   = "mlab-platform-network"
      stack_type = "IPV4_IPV6"
    }
    # TODO (kinkade): why is there an "epoxy" subnet in a region that already
    # has a "kubernetes" subnet? Is this to isolate epoxy from other things?
    # This is sort of problematic from the perspective of looping over the
    # subnetworks, since keys must be unique, and we cannot currently use the
    # subnetwork name, since that too is duplicated. We should either put epoxy
    # into its own, different region, and avoid putting platform nodes there,
    # or stop using the name "kubernetes" for all subnets platform subnetworks.
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
      "us-west2-epoxy" = {
        name          = "epoxy"
        ip_cidr_range = "10.3.0.0/16"
        region        = "us-west2"
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
