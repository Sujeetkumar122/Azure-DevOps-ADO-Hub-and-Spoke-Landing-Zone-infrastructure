variable "firewalls" {
  type = map(object({
    name                = string
    location            = string
    resource_group_name = string
    subnet_id           = string
    sku_name            = optional(string, "AZFW_VNet")
    sku_tier            = optional(string, "Standard")
    tags                = optional(map(string))
  }))
  description = "Map of Azure Firewalls to be created"
  default     = {}
}
