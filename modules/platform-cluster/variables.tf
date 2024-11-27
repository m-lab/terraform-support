variable "instances" {
  description = "Platform instances"
  type = object({
    attributes = object({
      daemonset        = string
      disk_image       = string
      disk_size_gb     = number
      disk_type        = string
      machine_type     = string
      mig_min_replicas = number
      mig_max_replicas = number
      network_tier     = string
      probability      = number
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

variable "ssh_keys" {
  description = "SSH public keys to add to project metadata"
  type        = list(map(string))
  default = [
    {
      user   = "nkinkade"
      pubkey = "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQDKVpmoO1NBwHATHqVF/2ig1y3u2GL00ulR+HIB2yoRnadxB8BdhGIAYaA+DQfVooZmxk+tGY4VExbaZMWvexCsfFKcSSfRCadBrPb64ycEqL4WUBCl2B1ys84BNYI8Fyg6RgRDFAzhCmG0Ho+rPPtW95cpqEzsZoINocQRhrjWvjzfrL71kUYzIlJDuGQbZPZjfOow/6H1UbkwJcF4vw4l9XngNrPCI1yLkdDT09x8O2baAbJ0GR0Dhlb3qWq9sE10tUMTx9MqtDRZeD4TxB0U4UEUH8Kfyrbgquq2oVklWhPIzo2XF3HptxaPjFWYkGKk530Lwk9qngAoQUK2qQmH nkinkade@npk-x260"
    },
    {
      user   = "roberto"
      pubkey = "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABgQCp/3VDEAqDeCWE0qDroTXB4ahmtwXG//bK7IcBSSGTWaZNQHos74Oge4lg/bPNcF8ZwEq5zDftoE6u2W/HaKN/tHTYvRJy+A0S4YeMUR5tK/VunuShgXfOIap8yzKe9sjKbczi+7mGU7sneTGSQ18JGGGSRlGXst2c5nQh5Fx7oxbDDDP0upx+/vR3CTHWRgbY7ghbxhLJ/cpI30TJOxEJYub4do3vVtEY3PrNQGBlVPg19K2PVU9TDH3zxdyXFpWoP2EbO1Mb9pO474DEIpZTEg6j+ElhKutrT9IkayqXwK2p64yVy5vM4WRydxGClKxu0NZ86qjTxVZVQUECvnxgxG7VINRkF6L/C9vBsKB6/cEzOuv3drmWzwLRbGgIodfp9RlMHQfS1v4hhb0kuQMM3BYq9MV+Nz94WaOU4mK6Pg1s29dYcEWhrNRHQ6kVmGOUMUUDbfzx8QNtgBzltthdRmgOZ06NibMBTtq3ZfbTrYTndmbL5SagBKtOi/wTw08= roberto@sycorax"
    }
  ]
}
