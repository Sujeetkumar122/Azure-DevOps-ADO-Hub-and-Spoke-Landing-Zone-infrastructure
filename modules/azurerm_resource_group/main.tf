terraform {
  required_version = ">= 1.3.0"
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = ">= 4.0.0"
    }
  }
}

resource "azurerm_resource_group" "rg" {
  for_each = var.resource_groups

  name     = each.value.name
  location = each.value.location
  tags     = each.value.tags
}