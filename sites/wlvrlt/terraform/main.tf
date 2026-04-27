terraform {
  required_version = ">= 1.6"
  required_providers {
    azurerm = { source = "hashicorp/azurerm", version = "~> 4.0" }
  }
  backend "azurerm" {
    use_azuread_auth = true
    use_oidc         = true
  }
}

provider "azurerm" {
  features {}
  subscription_id = var.subscription_id
  tenant_id       = var.tenant_id
  use_oidc        = true
}

module "site" {
  source = "../../../modules/static-web-app"

  name                    = var.name
  resource_group_name     = var.resource_group_name
  location                = var.location
  sku_tier                = var.sku_tier
  sku_size                = var.sku_size
  dns_zone_name           = var.dns_zone_name
  dns_zone_resource_group = var.dns_zone_resource_group
  bind_www                = var.bind_www
  bind_apex               = var.bind_apex
  tags                    = var.tags
}

output "default_host_name" { value = module.site.default_host_name }
output "name" { value = module.site.name }
output "resource_group" { value = module.site.resource_group_name }
output "deployment_token" {
  value     = module.site.api_key
  sensitive = true
}
