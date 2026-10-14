variable "resource_groups" {
  type = map(object({
    name     = string
    location = string
    tags     = optional(map(string))
  }))
  description = "Resource groups configuration"
}

variable "virtual_networks" {
  type = map(object({
    name                = string
    location            = string
    resource_group_name = string
    address_space       = list(string)
    dns_servers         = optional(list(string))
    tags                = optional(map(string))
  }))
  description = "Virtual networks configuration"
}

variable "subnets" {
  type = map(object({
    name                 = string
    resource_group_name  = string
    virtual_network_name = string
    address_prefixes     = list(string)
  }))
  description = "Subnets configuration"
}

variable "peerings" {
  type = map(object({
    name                         = string
    resource_group_name          = string
    virtual_network_name         = string
    remote_virtual_network_name  = string
    remote_resource_group_name   = string
    allow_virtual_network_access = optional(bool, true)
    allow_forwarded_traffic      = optional(bool, true)
    allow_gateway_transit        = optional(bool, false)
    use_remote_gateways          = optional(bool, false)
  }))
  description = "VNet Peering configuration"
  default     = {}
}

variable "network_security_groups" {
  type = map(object({
    name                = string
    location            = string
    resource_group_name = string
    tags                = optional(map(string))
    security_rules = optional(list(object({
      name                       = string
      priority                   = number
      direction                  = string
      access                     = string
      protocol                   = string
      source_port_range          = optional(string, "*")
      destination_port_range     = optional(string)
      source_address_prefix      = optional(string, "*")
      destination_address_prefix = optional(string, "*")
    })), [])
  }))
  description = "Network Security Groups configuration"
  default     = {}
}

variable "nsg_subnet_associations" {
  type = map(object({
    resource_group_name  = string
    virtual_network_name = string
    subnet_name          = string
    nsg_resource_group   = optional(string)
    nsg_name             = string
  }))
  description = "Subnet to NSG associations"
  default     = {}
}

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
  description = "Route Tables configuration"
  default     = {}
}

variable "route_table_subnet_associations" {
  type = map(object({
    resource_group_name  = string
    virtual_network_name = string
    subnet_name          = string
    route_table_rg       = optional(string)
    route_table_name     = string
  }))
  description = "Subnet to Route Table associations"
  default     = {}
}

variable "firewalls" {
  type = map(object({
    name                 = string
    location             = string
    resource_group_name  = string
    virtual_network_name = string
    subnet_name          = optional(string, "AzureFirewallSubnet")
    sku_name             = optional(string, "AZFW_VNet")
    sku_tier             = optional(string, "Standard")
    tags                 = optional(map(string))
  }))
  description = "Azure Firewall configuration"
  default     = {}
}

variable "bastion_hosts" {
  type = map(object({
    name                 = string
    location             = string
    resource_group_name  = string
    virtual_network_name = string
    subnet_name          = optional(string, "AzureBastionSubnet")
    sku                  = optional(string, "Basic")
    tags                 = optional(map(string))
  }))
  description = "Azure Bastion Hosts configuration"
  default     = {}
}

variable "log_analytics_workspaces" {
  type = map(object({
    name                = string
    location            = string
    resource_group_name = string
    sku                 = optional(string, "PerGB2018")
    retention_in_days   = optional(number, 30)
    tags                = optional(map(string))
  }))
  description = "Log Analytics Workspaces configuration"
  default     = {}
}

variable "key_vaults" {
  type = map(object({
    name                       = string
    location                   = string
    resource_group_name        = string
    sku_name                   = optional(string, "standard")
    soft_delete_retention_days = optional(number, 7)
    purge_protection_enabled   = optional(bool, false)
    tags                       = optional(map(string))
  }))
  description = "Key Vaults configuration"
  default     = {}
}

variable "linux_virtual_machines" {
  type = map(object({
    name                            = string
    location                        = string
    resource_group_name             = string
    virtual_network_name            = string
    subnet_name                     = string
    size                            = optional(string, "Standard_D2s_v4")
    zone                            = optional(string)
    admin_username                  = optional(string, "azureadmin")
    admin_password                  = optional(string, "P@ssw0rd12345!")
    disable_password_authentication = optional(bool, false)
    tags                            = optional(map(string))
  }))
  description = "Linux Virtual Machines configuration"
  default     = {}
}
