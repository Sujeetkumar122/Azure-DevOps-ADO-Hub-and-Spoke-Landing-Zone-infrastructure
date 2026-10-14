data "azurerm_client_config" "current" {}

locals {
  subscription_id = data.azurerm_client_config.current.subscription_id
}

# 1. Resource Groups Module
module "resource_groups" {
  source          = "../../modules/azurerm_resource_group"
  resource_groups = var.resource_groups
}

# 2. Virtual Networks Module
module "virtual_networks" {
  source           = "../../modules/azurerm_virtual_network"
  virtual_networks = var.virtual_networks

  depends_on = [module.resource_groups]
}

# 3. Subnets Module
module "subnets" {
  source  = "../../modules/azurerm_subnet"
  subnets = var.subnets

  depends_on = [module.virtual_networks]
}

# 4. Virtual Network Peering Module
module "virtual_network_peering" {
  source = "../../modules/azurerm_virtual_network_peering"
  peerings = {
    for k, v in var.peerings : k => {
      name                         = v.name
      resource_group_name          = v.resource_group_name
      virtual_network_name         = v.virtual_network_name
      remote_virtual_network_id    = "/subscriptions/${local.subscription_id}/resourceGroups/${v.remote_resource_group_name}/providers/Microsoft.Network/virtualNetworks/${v.remote_virtual_network_name}"
      allow_virtual_network_access = v.allow_virtual_network_access
      allow_forwarded_traffic      = v.allow_forwarded_traffic
      allow_gateway_transit        = v.allow_gateway_transit
      use_remote_gateways          = v.use_remote_gateways
    }
  }

  depends_on = [module.virtual_networks]
}

# 5. Network Security Group Module
module "network_security_group" {
  source                  = "../../modules/azurerm_network_security_group"
  network_security_groups = var.network_security_groups
  subnet_associations = {
    for k, v in var.nsg_subnet_associations : k => {
      subnet_id                 = "/subscriptions/${local.subscription_id}/resourceGroups/${v.resource_group_name}/providers/Microsoft.Network/virtualNetworks/${v.virtual_network_name}/subnets/${v.subnet_name}"
      network_security_group_id = "/subscriptions/${local.subscription_id}/resourceGroups/${v.resource_group_name}/providers/Microsoft.Network/networkSecurityGroups/${v.nsg_name}"
    }
  }

  depends_on = [module.subnets]
}

# 6. Route Table Module
module "route_table" {
  source       = "../../modules/azurerm_route_table"
  route_tables = var.route_tables
  subnet_associations = {
    for k, v in var.route_table_subnet_associations : k => {
      subnet_id      = "/subscriptions/${local.subscription_id}/resourceGroups/${v.resource_group_name}/providers/Microsoft.Network/virtualNetworks/${v.virtual_network_name}/subnets/${v.subnet_name}"
      route_table_id = "/subscriptions/${local.subscription_id}/resourceGroups/${v.resource_group_name}/providers/Microsoft.Network/routeTables/${v.route_table_name}"
    }
  }

  depends_on = [module.subnets]
}

# 7. Azure Firewall Module
module "firewall" {
  source = "../../modules/azurerm_firewall"
  firewalls = {
    for k, v in var.firewalls : k => {
      name                = v.name
      location            = v.location
      resource_group_name = v.resource_group_name
      subnet_id           = "/subscriptions/${local.subscription_id}/resourceGroups/${v.resource_group_name}/providers/Microsoft.Network/virtualNetworks/${v.virtual_network_name}/subnets/${v.subnet_name}"
      sku_name            = v.sku_name
      sku_tier            = v.sku_tier
      tags                = v.tags
    }
  }

  depends_on = [module.subnets]
}

# 8. Azure Bastion Host Module
module "bastion_host" {
  source = "../../modules/azurerm_bastion_host"
  bastion_hosts = {
    for k, v in var.bastion_hosts : k => {
      name                = v.name
      location            = v.location
      resource_group_name = v.resource_group_name
      subnet_id           = "/subscriptions/${local.subscription_id}/resourceGroups/${v.resource_group_name}/providers/Microsoft.Network/virtualNetworks/${v.virtual_network_name}/subnets/${v.subnet_name}"
      sku                 = v.sku
      tags                = v.tags
    }
  }

  depends_on = [module.subnets]
}

# 9. Log Analytics Workspace Module
module "log_analytics_workspace" {
  source                   = "../../modules/azurerm_log_analytics_workspace"
  log_analytics_workspaces = var.log_analytics_workspaces

  depends_on = [module.resource_groups]
}

# 10. Key Vault Module
module "key_vault" {
  source     = "../../modules/azurerm_key_vault"
  key_vaults = var.key_vaults

  depends_on = [module.resource_groups]
}

# 11. Linux Virtual Machine Module
module "linux_virtual_machine" {
  source = "../../modules/azurerm_linux_virtual_machine"
  linux_virtual_machines = {
    for k, v in var.linux_virtual_machines : k => {
      name                            = v.name
      location                        = v.location
      resource_group_name             = v.resource_group_name
      subnet_id                       = "/subscriptions/${local.subscription_id}/resourceGroups/${v.resource_group_name}/providers/Microsoft.Network/virtualNetworks/${v.virtual_network_name}/subnets/${v.subnet_name}"
      size                            = v.size
      zone                            = v.zone
      admin_username                  = v.admin_username
      admin_password                  = v.admin_password
      disable_password_authentication = v.disable_password_authentication
      tags                            = v.tags
    }
  }

  depends_on = [module.subnets, module.route_table, module.network_security_group]
}