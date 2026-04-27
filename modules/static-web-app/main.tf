terraform {
  required_version = ">= 1.6"
  required_providers {
    azurerm = { source = "hashicorp/azurerm", version = "~> 4.0" }
  }
}

resource "azurerm_resource_group" "this" {
  name     = var.resource_group_name
  location = var.location
  tags     = var.tags
}

resource "azurerm_static_web_app" "this" {
  name                = var.name
  resource_group_name = azurerm_resource_group.this.name
  location            = var.location
  sku_tier            = var.sku_tier
  sku_size            = var.sku_size
  tags                = var.tags
}

# www subdomain (CNAME → <swa>.azurestaticapps.net) and bind via cname-delegation.
resource "azurerm_dns_cname_record" "www" {
  count               = var.bind_www ? 1 : 0
  name                = "www"
  zone_name           = var.dns_zone_name
  resource_group_name = var.dns_zone_resource_group
  ttl                 = 300
  record              = azurerm_static_web_app.this.default_host_name
  tags                = var.tags
}

resource "azurerm_static_web_app_custom_domain" "www" {
  count             = var.bind_www ? 1 : 0
  static_web_app_id = azurerm_static_web_app.this.id
  domain_name       = "www.${var.dns_zone_name}"
  validation_type   = "cname-delegation"

  depends_on = [azurerm_dns_cname_record.www]
}

# Apex (zone root) — DNS alias A-record + dns-txt-token validation.
# Bind apex only after `bind_www` has succeeded once (Azure SWA needs the
# www binding to exist before it will issue the apex domain validation token
# reliably). Set `bind_apex = true` on a follow-up apply.
resource "azurerm_dns_a_record" "apex" {
  count               = var.bind_apex ? 1 : 0
  name                = "@"
  zone_name           = var.dns_zone_name
  resource_group_name = var.dns_zone_resource_group
  ttl                 = 300
  target_resource_id  = azurerm_static_web_app.this.id
  tags                = var.tags
}

resource "azurerm_static_web_app_custom_domain" "apex" {
  count             = var.bind_apex ? 1 : 0
  static_web_app_id = azurerm_static_web_app.this.id
  domain_name       = var.dns_zone_name
  validation_type   = "dns-txt-token"

  depends_on = [azurerm_dns_a_record.apex]
}
