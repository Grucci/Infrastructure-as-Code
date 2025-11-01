# Busca dados do EA
data "azurerm_billing_enrollment_account_scope" "example" {
    billing_account_name    = var.billing_account_name
    enrollment_account_name = var.enrollment_account_name
}

# Criação única da subscription
resource "azurerm_subscription" "this" {
    provider          = azurerm.selected
    subscription_name = var.subscription_name
    billing_scope_id  = data.azurerm_billing_enrollment_account_scope.example.id
}

# Associação ao Management Group
resource "azurerm_management_group_subscription_association" "mg_association" {
    management_group_id = var.management_group_id
    subscription_id     = azurerm_subscription.this.subscription_id
}