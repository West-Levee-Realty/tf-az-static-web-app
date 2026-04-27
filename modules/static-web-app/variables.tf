variable "name" {
  type        = string
  description = "Static Web App name"
}

variable "resource_group_name" {
  type        = string
  description = "Resource group for the Static Web App"
}

variable "location" {
  type        = string
  description = "Azure region (SWA supported regions only)"
}

variable "sku_tier" {
  type        = string
  description = "Free or Standard"
  default     = "Free"
  validation {
    condition     = contains(["Free", "Standard"], var.sku_tier)
    error_message = "sku_tier must be Free or Standard."
  }
}

variable "sku_size" {
  type        = string
  default     = "Free"
}

variable "dns_zone_name" {
  type        = string
  description = "Apex DNS zone (e.g. wlvrlt.com)"
}

variable "dns_zone_resource_group" {
  type        = string
  description = "Resource group containing the DNS zone"
}

variable "bind_www" {
  type        = bool
  default     = true
  description = "Bind www.<zone> as a custom domain"
}

variable "bind_apex" {
  type        = bool
  default     = false
  description = "Bind <zone> apex as a custom domain (set true on a second apply, after www bind succeeds)"
}

variable "tags" {
  type    = map(string)
  default = {}
}
