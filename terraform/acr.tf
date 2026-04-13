# Azure Container Registry (ACR)
resource "azurerm_container_registry" "acr" {
  name                = var.acr_name
  resource_group_name = data.azurerm_resource_group.devsecops.name
  location            = data.azurerm_resource_group.devsecops.location
  sku                 = "Standard"
  admin_enabled       = true

  tags = {
    Environment = var.environment
  }
}

# Attach ACR to AKS
resource "azurerm_role_assignment" "aks_acr" {
  scope              = azurerm_container_registry.acr.id
  role_definition_name = "AcrPull"
  principal_id       = azurerm_kubernetes_cluster.aks.identity[0].principal_id
}