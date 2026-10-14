terraform {
  required_version = ">= 1.3.0"
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = ">= 4.0.0"
    }
  }
}

resource "azurerm_public_ip" "pip" {
  for_each            = var.firewalls
  name                = "${each.value.name}-pip"
  location            = each.value.location
  resource_group_name = each.value.resource_group_name
  allocation_method   = "Static"
  sku                 = "Standard"
  tags                = each.value.tags
}

resource "azurerm_firewall" "fw" {
  for_each            = var.firewalls
  name                = each.value.name
  location            = each.value.location
  resource_group_name = each.value.resource_group_name
  sku_name            = each.value.sku_name
  sku_tier            = each.value.sku_tier
  tags                = each.value.tags

  ip_configuration {
    name                 = "configuration"
    subnet_id            = each.value.subnet_id
    public_ip_address_id = azurerm_public_ip.pip[each.key].id
  }
}
