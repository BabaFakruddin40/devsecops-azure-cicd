# Azure Kubernetes Service (AKS)
resource "azurerm_kubernetes_cluster" "aks" {
  name                = var.cluster_name
  location            = data.azurerm_resource_group.devsecops.location
  resource_group_name = data.azurerm_resource_group.devsecops.name
  dns_prefix          = var.cluster_name

  oidc_issuer_enabled = true

  # If you are using Workload Identity, it usually goes hand-in-hand:
  workload_identity_enabled = true

  default_node_pool {
    name       = "default"
    node_count = var.node_count
    vm_size    = var.vm_size

    tags = {
      Environment = var.environment
    }
  }

  identity {
    type = "SystemAssigned"
  }

  network_profile {
    network_plugin    = "azure"
    load_balancer_sku = "standard"
  }

  tags = {
    Environment = var.environment
  }

  depends_on = [
    data.azurerm_resource_group.devsecops
  ]
}

# Get AKS credentials
resource "null_resource" "get_credentials" {
  provisioner "local-exec" {
    command = "az aks get-credentials --resource-group ${data.azurerm_resource_group.devsecops.name} --name ${azurerm_kubernetes_cluster.aks.name} --overwrite-existing"
  }

  depends_on = [data.azurerm_resource_group.devsecops]
}