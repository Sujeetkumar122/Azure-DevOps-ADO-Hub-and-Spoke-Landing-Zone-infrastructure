variable "bastion_hosts" {
  type = map(object({
    name                = string
    location            = string
    resource_group_name = string
    subnet_id           = string
    sku                 = optional(string, "Basic")
    tags                = optional(map(string))
  }))
  description = "Map of Azure Bastion Hosts to be created"
  default     = {}
}
