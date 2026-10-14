resource_groups = {
  rg_hub = {
    name     = "rg-hub-preprod"
    location = "East US"
    tags = {
      Environment = "preprod"
      Role        = "Hub"
      ManagedBy   = "Terraform"
    }
  }

  rg_spoke = {
    name     = "rg-spoke-preprod"
    location = "East US"
    tags = {
      Environment = "preprod"
      Role        = "Spoke"
      ManagedBy   = "Terraform"
    }
  }
}

virtual_networks = {
  vnet_hub = {
    name                = "vnet-hub-preprod"
    location            = "East US"
    resource_group_name = "rg-hub-preprod"
    address_space       = ["10.10.0.0/16"]
    tags = {
      Environment = "preprod"
      Tier        = "Hub-Network"
    }
  }

  vnet_spoke = {
    name                = "vnet-spoke-preprod"
    location            = "East US"
    resource_group_name = "rg-spoke-preprod"
    address_space       = ["10.20.0.0/16"]
    tags = {
      Environment = "preprod"
      Tier        = "Spoke-Network"
    }
  }
}

subnets = {
  snet_firewall = {
    name                 = "AzureFirewallSubnet"
    resource_group_name  = "rg-hub-preprod"
    virtual_network_name = "vnet-hub-preprod"
    address_prefixes     = ["10.10.1.0/26"]
  }

  snet_bastion = {
    name                 = "AzureBastionSubnet"
    resource_group_name  = "rg-hub-preprod"
    virtual_network_name = "vnet-hub-preprod"
    address_prefixes     = ["10.10.2.0/26"]
  }

  snet_hub_mgmt = {
    name                 = "snet-hub-mgmt"
    resource_group_name  = "rg-hub-preprod"
    virtual_network_name = "vnet-hub-preprod"
    address_prefixes     = ["10.10.3.0/24"]
  }

  snet_spoke_workload = {
    name                 = "snet-spoke-workload"
    resource_group_name  = "rg-spoke-preprod"
    virtual_network_name = "vnet-spoke-preprod"
    address_prefixes     = ["10.20.1.0/24"]
  }
}

peerings = {
  hub_to_spoke = {
    name                         = "peer-hub-to-spoke-preprod"
    resource_group_name          = "rg-hub-preprod"
    virtual_network_name         = "vnet-hub-preprod"
    remote_resource_group_name   = "rg-spoke-preprod"
    remote_virtual_network_name  = "vnet-spoke-preprod"
    allow_virtual_network_access = true
    allow_forwarded_traffic      = true
  }

  spoke_to_hub = {
    name                         = "peer-spoke-to-hub-preprod"
    resource_group_name          = "rg-spoke-preprod"
    virtual_network_name         = "vnet-spoke-preprod"
    remote_resource_group_name   = "rg-hub-preprod"
    remote_virtual_network_name  = "vnet-hub-preprod"
    allow_virtual_network_access = true
    allow_forwarded_traffic      = true
  }
}

network_security_groups = {
  nsg_spoke = {
    name                = "nsg-spoke-workload-preprod"
    location            = "East US"
    resource_group_name = "rg-spoke-preprod"
    security_rules = [
      {
        name                       = "AllowSSH"
        priority                   = 100
        direction                  = "Inbound"
        access                     = "Allow"
        protocol                   = "Tcp"
        destination_port_range     = "22"
        source_address_prefix      = "VirtualNetwork"
        destination_address_prefix = "*"
      },
      {
        name                       = "AllowHTTP"
        priority                   = 110
        direction                  = "Inbound"
        access                     = "Allow"
        protocol                   = "Tcp"
        destination_port_range     = "80"
        source_address_prefix      = "*"
        destination_address_prefix = "*"
      }
    ]
  }
}

nsg_subnet_associations = {
  spoke_workload = {
    resource_group_name  = "rg-spoke-preprod"
    virtual_network_name = "vnet-spoke-preprod"
    subnet_name          = "snet-spoke-workload"
    nsg_name             = "nsg-spoke-workload-preprod"
  }
}

route_tables = {
  rt_spoke = {
    name                = "rt-spoke-preprod"
    location            = "East US"
    resource_group_name = "rg-spoke-preprod"
    routes = [
      {
        name                   = "route-to-firewall"
        address_prefix         = "0.0.0.0/0"
        next_hop_type          = "VirtualAppliance"
        next_hop_in_ip_address = "10.10.1.4"
      }
    ]
  }
}

route_table_subnet_associations = {
  spoke_workload = {
    resource_group_name  = "rg-spoke-preprod"
    virtual_network_name = "vnet-spoke-preprod"
    subnet_name          = "snet-spoke-workload"
    route_table_name     = "rt-spoke-preprod"
  }
}

firewalls = {
  fw_hub = {
    name                 = "afw-hub-preprod"
    location             = "East US"
    resource_group_name  = "rg-hub-preprod"
    virtual_network_name = "vnet-hub-preprod"
    subnet_name          = "AzureFirewallSubnet"
    sku_name             = "AZFW_VNet"
    sku_tier             = "Standard"
  }
}

bastion_hosts = {
  bastion_hub = {
    name                 = "bas-hub-preprod"
    location             = "East US"
    resource_group_name  = "rg-hub-preprod"
    virtual_network_name = "vnet-hub-preprod"
    subnet_name          = "AzureBastionSubnet"
    sku                  = "Basic"
  }
}

log_analytics_workspaces = {
  law_hub = {
    name                = "law-hub-preprod"
    location            = "East US"
    resource_group_name = "rg-hub-preprod"
    sku                 = "PerGB2018"
    retention_in_days   = 30
  }
}

key_vaults = {
  kv_hub = {
    name                = "kv-hub-preprod-sujeet"
    location            = "East US"
    resource_group_name = "rg-hub-preprod"
    sku_name            = "standard"
  }
}

linux_virtual_machines = {
  vm_spoke = {
    name                            = "vm-spoke-preprod"
    location                        = "East US"
    resource_group_name             = "rg-spoke-preprod"
    virtual_network_name            = "vnet-spoke-preprod"
    subnet_name                     = "snet-spoke-workload"
    size                            = "Standard_D2s_v4"
    admin_username                  = "azureadmin"
    admin_password                  = "P@ssw0rd12345!"
    disable_password_authentication = false
  }
}