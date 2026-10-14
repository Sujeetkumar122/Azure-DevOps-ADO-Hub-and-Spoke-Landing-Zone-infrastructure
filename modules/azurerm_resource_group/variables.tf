variable "resource_groups" {
  type = map(object({
    name     = string
    location = string
    tags     = optional(map(string))
  }))
  description = "Map of resource groups to be created"
}