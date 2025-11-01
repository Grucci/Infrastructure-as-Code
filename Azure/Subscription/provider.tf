# Provider dinâmico — só precisamos informar o tenant_id
provider "azurerm" {
    alias    = "selected"
    features {}
    tenant_id = var.tenant_id
}

terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = ">=3.0.0"
    }
  }
}

provider "azurerm" {
  features  {}
  tenant_id = var.tenant_id
}