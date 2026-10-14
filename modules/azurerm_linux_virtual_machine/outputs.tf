output "vm_details" {
  description = "Detailed map of deployed Linux Virtual Machines (Private IP, Hostname, VM ID, Location)"
  value = {
    for k, vm in azurerm_linux_virtual_machine.vm : k => {
      id                 = vm.id
      name               = vm.name
      private_ip_address = azurerm_network_interface.nic[k].private_ip_address
      location           = vm.location
      resource_group     = vm.resource_group_name
      size               = vm.size
    }
  }
}

output "vm_ids" {
  description = "Map of VM IDs"
  value       = { for k, vm in azurerm_linux_virtual_machine.vm : k => vm.id }
}

output "vm_private_ips" {
  description = "Map of VM private IP addresses"
  value       = { for k, nic in azurerm_network_interface.nic : k => nic.private_ip_address }
}

output "vm_names" {
  description = "Map of VM hostnames / names"
  value       = { for k, vm in azurerm_linux_virtual_machine.vm : k => vm.name }
}
