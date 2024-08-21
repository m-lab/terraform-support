variable "node_pools" {
  default = {
    "pipeline" = {
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
