variable "instances" {
  description = "Google OIM instances"
  type = object({
    attributes = object({
      disk_image       = string
      disk_size_gb     = number
      disk_type        = string
      machine_type     = string
      probability      = number
    })
    vms = map(map(string))
  })
}

variable "networking" {
  description = "Network details for Google OIM instances"
  type = object({
    attributes  = map(string)
    subnetworks = map(map(string))
  })
}

