# Sirf VM ke details (jaise Private IP, VM ID) ke liye

output "vm_details" {
  description = "Linux Virtual Machine details including Private IP, VM ID, Hostname"
  value       = module.linux_virtual_machine.vm_details
}

output "vm_ids" {
  description = "VM IDs of deployed Linux Virtual Machines"
  value       = module.linux_virtual_machine.vm_ids
}

output "vm_private_ips" {
  description = "Private IP addresses of deployed Linux Virtual Machines"
  value       = module.linux_virtual_machine.vm_private_ips
}

output "vm_names" {
  description = "Hostnames/names of deployed Linux Virtual Machines"
  value       = module.linux_virtual_machine.vm_names
}
