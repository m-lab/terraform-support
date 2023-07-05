variable "project" {
  description = "GCP project"
  type        = string
}

variable "default_region" {
  description = "Default GCP region"
  type        = string
}

variable "default_zone" {
  description = "Default GCP zone"
  type        = string
}

variable "instances" {
  description = "Platform instances"
  type = object({
    attributes = object({
      disk_image       = string
      disk_size_gb     = number
      disk_type        = string
      machine_type     = string
      mig_min_replicas = number
      mig_max_replicas = number
      network_tier     = string
      tags             = list(string)
      scopes           = list(string)
    })
    migs = map(map(string))
    vms  = map(map(string))
  })
}

variable "api_instances" {
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
  description = "Network details for platform instances"
  type = object({
    attributes  = map(string)
    subnetworks = map(map(string))
  })
}
