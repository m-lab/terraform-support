variable "node_pools" {
  description = "Cluster node pools"
  type = map(
    object({
      initial_node_count = number
      machine_type       = string
      max_node_count     = number
      max_surge          = number
      oauth_scopes       = list(string)
    })
  )
}
