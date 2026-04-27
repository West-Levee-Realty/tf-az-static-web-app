variable "tenant_id" { type = string }
variable "subscription_id" { type = string }

variable "name" { type = string }
variable "resource_group_name" { type = string }
variable "location" { type = string }
variable "sku_tier" { type = string }
variable "sku_size" { type = string }
variable "dns_zone_name" { type = string }
variable "dns_zone_resource_group" { type = string }

variable "bind_www" {
  type    = bool
  default = true
}

variable "bind_apex" {
  type    = bool
  default = false
}

variable "tags" {
  type    = map(string)
  default = {}
}
