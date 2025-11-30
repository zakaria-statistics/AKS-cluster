# Get info about the current Azure client (useful later for RBAC, etc.)
data "azurerm_client_config" "current" {}

# Resource group
resource "azurerm_resource_group" "rg" {
  name     = var.resource_group_name
  location = var.location
}

# Virtual network
resource "azurerm_virtual_network" "vnet" {
  name                = "${var.aks_name}-vnet"
  address_space       = [var.vnet_cidr]
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name
  tags                = var.tags
}

# Subnet for AKS nodes
resource "azurerm_subnet" "aks_subnet" {
  name                 = "${var.aks_name}-subnet"
  resource_group_name  = azurerm_resource_group.rg.name
  virtual_network_name = azurerm_virtual_network.vnet.name
  address_prefixes     = [var.aks_subnet_cidr]

  # Delegation is recommended when using advanced features / API server VNet integration,
  # but not strictly required for a basic cluster. Example if you want it:
  # delegation {
  #   name = "aks-delegation"
  #   service_delegation {
  #     name = "Microsoft.ContainerService/managedClusters"
  #     actions = [
  #       "Microsoft.Network/virtualNetworks/subnets/join/action",
  #       "Microsoft.Network/virtualNetworks/subnets/prepareNetworkPolicies/action",
  #     ]
  #   }
  # }
}

# Log Analytics for monitoring (used by OMS agent)
resource "azurerm_log_analytics_workspace" "law" {
  count               = var.enable_monitoring ? 1 : 0
  name                = "${var.aks_name}-law"
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name
  sku                 = "PerGB2018"
  retention_in_days   = 30
  tags                = var.tags
}

# AKS cluster
resource "azurerm_kubernetes_cluster" "aks" {
  name                = var.aks_name
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name
  dns_prefix          = var.dns_prefix

  # Recommended: managed identity
  identity {
    type = "SystemAssigned"
  }

  # Linux profile (SSH access to nodes if needed)
  linux_profile {
    admin_username = var.admin_username

    ssh_key {
      key_data = var.ssh_public_key
    }
  }

  default_node_pool {
    name                 = "system"
    vm_size              = var.node_vm_size
    node_count           = var.node_count
    vnet_subnet_id       = azurerm_subnet.aks_subnet.id
    type                 = "VirtualMachineScaleSets"
    orchestrator_version = "1.30.0" # or leave null for latest supported

  }

  # Basic networking: Azure CNI (good for most cases)
  network_profile {
    network_plugin = "azure"  # or "kubenet"
    network_policy = "calico" # optional, for network policies
    dns_service_ip = "10.0.0.10"
    service_cidr   = "10.0.0.0/16"
  }

  # Enable RBAC (you can later integrate Entra ID / Azure AD here)
  role_based_access_control_enabled = true

  # Monitoring only if enabled
  dynamic "oms_agent" {
    for_each = var.enable_monitoring ? [1] : []
    content {
      log_analytics_workspace_id = azurerm_log_analytics_workspace.law.id
    }
  }

  tags = var.tags

  lifecycle {
    ignore_changes = [
      default_node_pool[0].node_count
    ]
  }
}
