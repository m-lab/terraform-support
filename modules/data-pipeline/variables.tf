variable "node_pools" {
  description = "Cluster node pools"
  type = map(
    object({
      initial_node_count = number
      labels             = map(string)
      machine_type       = string
      max_node_count     = number
      max_surge          = number
      max_unavailable    = number
      min_node_count     = number
      oauth_scopes       = list(string)
      service_account    = string
    })
  )
}
