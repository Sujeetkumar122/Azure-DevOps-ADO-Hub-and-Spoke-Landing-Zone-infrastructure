variable "key_vaults" {
  type = map(object({
    name                       = string
    location                   = string
    resource_group_name        = string
    sku_name                   = optional(string, "standard")
    tenant_id                  = optional(string)
    object_id                  = optional(string)
    soft_delete_retention_days = optional(number, 7)
    purge_protection_enabled   = optional(bool, false)
    rbac_authorization_enabled = optional(bool, false)
    key_permissions            = optional(list(string))
    secret_permissions         = optional(list(string))
    certificate_permissions    = optional(list(string))
    tags                       = optional(map(string))
  }))
  description = "Map of Key Vaults to be created"
  default     = {}
}
