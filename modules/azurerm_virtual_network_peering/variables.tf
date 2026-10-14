variable "peerings" {
  type = map(object({
    name                         = string
    resource_group_name          = string
    virtual_network_name         = string
    remote_virtual_network_id    = string
    allow_virtual_network_access = optional(bool, true)
    allow_forwarded_traffic      = optional(bool, true)
    allow_gateway_transit        = optional(bool, false)
    use_remote_gateways          = optional(bool, false)
  }))
  description = "Map of virtual network peerings to be created"
}
