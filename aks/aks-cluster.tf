provider "azurerm" {
  version = "~> 2.0"
  features {}
}

terraform {
  backend "azurerm" {
    resource_group_name  = "zimagi-tf"
    storage_account_name = "zimagitfbackend"
    container_name       = "terraform-state"
    key                  = "terraform.tfstate"
  }
}

resource "azurerm_resource_group" "default" {
  name     = "${var.namePrefix}-rg"
  location = "${var.location}"

  tags = {
    environment = var.namePrefix,
  }
}

resource "azurerm_public_ip" "default" {
  name                = "AKSPublicIp"
  location            = azurerm_resource_group.default.location
  resource_group_name = "${azurerm_resource_group.default.name}"
  allocation_method   = "Static"
}

resource "azurerm_kubernetes_cluster" "default" {
  name                = "${var.namePrefix}-aks"
  location            = azurerm_resource_group.default.location
  resource_group_name = azurerm_resource_group.default.name
  dns_prefix          = "${var.namePrefix}-k8s"

  default_node_pool {
    name            = "default"
    node_count      = 1
    vm_size         = "Standard_D2_v2"
    os_disk_size_gb = 30
  }


  role_based_access_control {
    enabled = true
  }

  addon_profile {
    kube_dashboard {
      enabled = true
    }
  }

  identity {
    type = "SystemAssigned"
  }

  tags = {
    environment = var.namePrefix,
  }
}