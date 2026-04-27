output "id" {
  value = azurerm_static_web_app.this.id
}

output "default_host_name" {
  value = azurerm_static_web_app.this.default_host_name
}

output "name" {
  value = azurerm_static_web_app.this.name
}

output "resource_group_name" {
  value = azurerm_resource_group.this.name
}

output "api_key" {
  value     = azurerm_static_web_app.this.api_key
  sensitive = true
}
