resource "azurerm_resource_group" "example" {
    name     = "rg${var.rg_foundation.environment}${var.resource_group.name}"
    location = var.rg_foundation.location
    tags     = var.tags
}