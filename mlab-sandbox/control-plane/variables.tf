variable "project" {
  default     = "mlab-sandbox"
  description = "GCP project of resources"
  type        = string
}

variable "prometheus_instance" {
  default = {
    disk_image        = "platform-cluster-internal-instance-latest"
    disk_size_gb_boot = 100
    disk_size_gb_data = 200
    disk_type         = "pd-ssd"
    machine_type      = "n2-standard-2"
    tags              = ["prometheus-platform-cluster"]
    region            = "us-south1"
    scopes            = ["cloud-platform"]
    zone              = "us-south1-a"
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

variable "api_instances" {
  default = {
    machine_attributes = {
      disk_image        = "platform-cluster-api-instance-latest"
      disk_size_gb_boot = 100
      disk_size_gb_data = 10
      # This will show up as /dev/disk/by-id/google-<name>
      disk_dev_name_data = "cluster-data"
      disk_type          = "pd-ssd"
      machine_type       = "n2-standard-2"
      tags               = ["platform-cluster"]
      region             = "us-south1"
      scopes             = ["cloud-platform"]
    }
    cluster_attributes = {
      cluster_cidr     = "192.168.0.0/16"
      lb_dns           = "kinkade-test-lb.mlab-sandbox.measurementlab.net"
      service_cidr     = "172.25.0.0/16"
      token_server_dns = "kinkade-test-token-server-platform-cluster.mlab-sandbox.measurementlab.net"
    }
    zones = {
      "us-south1-a" = {
        "create_role" = "init",
        "reboot_day"  = "Tue"
      },
      "us-south1-b" = {
        "create_role" = "join",
        "reboot_day"  = "Wed"
      },
      "us-south1-c" = {
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

variable "networking" {
  default = {
    attributes = {
      vpc_name   = "platform-network-kinkade-test"
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
      "us-south1" = {
        ip_cidr_range = "10.0.0.0/16"
        name          = "kinkade-test-kubernetes"
        region        = "us-south1"
      },
      "us-south1-epoxy" = {
        name          = "kinkade-test-epoxy"
        ip_cidr_range = "10.3.0.0/16"
        region        = "us-south1"
      }
    }
  }
  description = "Network details for platform instances"
  type = object({
    attributes  = map(string)
    subnetworks = map(map(string))
  })
}
