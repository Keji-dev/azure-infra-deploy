resource "azurerm_kubernetes_cluster" "example" {
    name                = "kubernetes-cluster"
    location            = azurerm_resource_group.rg-deploy.location
    resource_group_name = azurerm_resource_group.rg-deploy.name
    dns_prefix          = "aks-cluster"

    default_node_pool {
        name       = "default"
        node_count = 1
        vm_size    = "Standard_D2_v2"
    }

    identity {
        type = "SystemAssigned"
    }

    tags = {
        Environment = "dev"
    }

    private_cluster_enabled = false
    
   depends_on = [
        azurerm_container_registry.acr-dev-cp2
    ]
}

resource "azurerm_role_assignment" "aks_acr_access" {
  principal_id          = azurerm_kubernetes_cluster.example.identity[0].principal_id
  role_definition_name  = "AcrPull" 
  scope                 = azurerm_container_registry.acr-dev-cp2.id  
}

