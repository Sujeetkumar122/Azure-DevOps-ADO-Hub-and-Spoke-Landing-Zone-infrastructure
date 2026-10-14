variable "route_tables" {
  type = map(object({
    name                          = string
    location                      = string
    resource_group_name           = string
    bgp_route_propagation_enabled = optional(bool, true)
    tags                          = optional(map(string))
    routes = optional(list(object({
      name                   = string
      address_prefix         = string
      next_hop_type          = string
      next_hop_in_ip_address = optional(string)
    })), [])
  }))
  description = "Map of Route Tables to be created"
  default     = {}
}

variable "subnet_associations" {
  type = map(object({
    subnet_id       = string
    route_table_id  = optional(string)
    route_table_key = optional(string)
  }))
  description = "Map of Subnet Route Table associations"
  default     = {}
}
