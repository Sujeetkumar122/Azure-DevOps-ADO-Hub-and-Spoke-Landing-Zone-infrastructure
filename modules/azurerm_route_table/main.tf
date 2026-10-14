terraform {
  required_version = ">= 1.3.0"
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = ">= 4.0.0"
    }
  }
}

resource "azurerm_route_table" "rt" {
  for_each                      = var.route_tables
  name                          = each.value.name
  location                      = each.value.location
  resource_group_name           = each.value.resource_group_name
  bgp_route_propagation_enabled = each.value.bgp_route_propagation_enabled
  tags                          = each.value.tags

  dynamic "route" {
    for_each = each.value.routes
    content {
      name                   = route.value.name
      address_prefix         = route.value.address_prefix
      next_hop_type          = route.value.next_hop_type
      next_hop_in_ip_address = route.value.next_hop_in_ip_address
    }
  }
}

resource "azurerm_subnet_route_table_association" "rt_assoc" {
  for_each       = var.subnet_associations
  subnet_id      = each.value.subnet_id
  route_table_id = each.value.route_table_id
}
