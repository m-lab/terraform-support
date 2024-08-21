variable "node_pools" {
  description = "Cluster node pools"
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
  description = "GAE subnet region"
  type        = string
  default     = "us-central1"
}
