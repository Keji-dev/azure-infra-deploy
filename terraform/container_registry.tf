resource "azurerm_container_registry" "acr-dev-cp2" {
  name                = "acrdevcp2"
  resource_group_name = azurerm_resource_group.rg-deploy.name
  location            = azurerm_resource_group.rg-deploy.location
  sku                 = "Basic"
  admin_enabled       = false
  public_network_access_enabled = true
}