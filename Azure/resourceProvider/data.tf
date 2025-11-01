data "azurerm_subscription" "target" {
}

output "subscription_id" {
    value = data.azurerm_subscription.target.id
}