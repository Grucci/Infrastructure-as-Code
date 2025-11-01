resource "azurerm_resource_provider_registration" "rp" {
    for_each = var.register_resource_providers ? toset(var.azurerm_resource_provider_name) : []

    provider = azurerm.subscription_target
    name = each.value 
}

resource "azurerm_resource_provider_registration" "feature" {
    # count = var.register_feature ? 1 : 0

    provider = azurerm.subscription_target
    name     = var.azurerm_rp_feature_name

    feature {
        name = var.azurerm_feature_feature_name
        registered = var.feature_registered
    }

    depends_on = [ azurerm_resource_provider_registration.rp ]
}