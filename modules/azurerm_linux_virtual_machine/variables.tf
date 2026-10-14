variable "linux_virtual_machines" {
  type = map(object({
    name                            = string
    location                        = string
    resource_group_name             = string
    subnet_id                       = string
    size                            = optional(string, "Standard_D2s_v4")
    zone                            = optional(string)
    admin_username                  = optional(string, "azureadmin")
    admin_password                  = optional(string, "P@ssw0rd12345!")
    disable_password_authentication = optional(bool, false)
    tags                            = optional(map(string))
  }))
  description = "Map of Linux Virtual Machines to be created"
  default     = {}
}
