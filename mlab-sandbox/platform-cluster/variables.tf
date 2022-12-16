variable "project" {
  default     = "mlab-sandbox"
  description = "The GCP project to use"
  type        = string
}

variable "machine_type" {
  default     = "n2-highcpu-4"
  description = "The GCE machine-type to use for VMs"
  type        = string
}

variable "network" {
  default     = "mlab-platform-network"
  description = "The VPC network to use for resources"
  type        = string
}

variable "subnetwork" {
  default     = "kubernetes"
  description = "The VPC subnetwork to use for resources"
  type        = string
}

variable "stack_type" {
  default     = "IPV4_IPV6"
  description = "The network stack type for VMs"
  type        = string
}

variable "vm_scopes" {
  default     = ["cloud-platform"]
  description = "The access scopes to use for VMs"
  type        = list(string)
}

variable "disk_size_gb" {
  default     = 100
  description = "The size of the boot disk, in GB"
  type        = number
}

variable "disk_type" {
  default     = "pd-ssd"
  description = "The type of persistent disk to use for the boot disk"
  type        = string
}

variable "disk_image" {
  default     = "mlab-platform-cluster-latest"
  description = "The image to use to create the boot disk"
  type        = string
}

variable "tags" {
  default     = ["ndt-cloud"]
  description = "The tags to add to the VM"
  type        = list(string)
}

variable "control_plane_region" {
  default     = "us-west2"
  description = "GCP region for control plane resources"
  type        = string
}

variable "control_plane_zones" {
  default     = ["a", "b", "c"]
  description = "Zones for redundant control plane nodes"
  type        = list(string)
}

variable "k8s_subnetworks" {
  default = {
    "us-west2" = "10.0.0.0/16"
    "us_west1" = "10.2.0.0/16"
    "us-east1" = "10.4.0.0/16"
  }
  description = "Subnetworks for platform cluster nodes"
  type        = map(any)
}
