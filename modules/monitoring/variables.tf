variable "region" {
  description = "GCP region for the monitoring VM and subnet"
  type        = string
}

variable "zone" {
  description = "GCP zone for the monitoring VM"
  type        = string
}

variable "subnet_cidr" {
  description = "IPv4 CIDR for the monitoring subnet (must not overlap with existing subnets in the default network)"
  type        = string
}
