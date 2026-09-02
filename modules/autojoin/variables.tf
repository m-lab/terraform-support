variable "node_pools" {
  default = {
    "processor" = {
      initial_node_count = 1
      machine_type       = "n2-standard-4"
      max_node_count     = 3
      max_surge          = 1
    },
    "monitoring" = {
      initial_node_count = 1
      machine_type       = "n2-standard-4"
      max_node_count     = 3
      max_surge          = 1
    }
  }
  description = "Cluster node pools"
  type = map(
    object({
      initial_node_count = number
      machine_type       = string
      max_node_count     = number
      max_surge          = number
    })
  )
}

variable "appengine_region" {
  default     = "us-central1"
  description = "GAE subnet region"
  type        = string
}

variable "deploy_autonode_deb" {
  default     = false
  description = "Whether to deploy the autonode-deb VM, used to test the mlab-node Debian package"
  type        = bool
}

variable "autonode_deb_zone" {
  default     = null
  description = "Zone for the autonode-deb VM, overriding the provider default. Must stay in us-central1 (the deploy pipeline assumes the OMA IATA)."
  type        = string
}

variable "autonode_deb_machine_type" {
  default     = "n2-standard-2"
  description = "Machine type for the autonode-deb VM. Defaults to the autonode VM's type; override when a zone is out of capacity."
  type        = string
}
