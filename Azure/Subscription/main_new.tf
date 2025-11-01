# Escopo do Billing (EA)
data "azurerm_billing_enrollment_account_scope" "this" {
  billing_account_name    = var.billing_account_name
  enrollment_account_name = var.enrollment_account_name
}

# Criação da Subscription
resource "azurerm_subscription" "this" {
  subscription_name = lookup(var.subscription_name_map, var.tenant_id, "Default-Subscription")
  billing_scope_id  = data.azurerm_billing_enrollment_account_scope.this.id

  tags = lookup(var.subscription_tags_map, var.tenant_id, {
    "Owner"       = "Default"
    "Environment" = "Unknown"
  })
}

# Associação ao Management Group
resource "azurerm_management_group_subscription_association" "this" {
  management_group_id = var.management_group_id
  subscription_id     = azurerm_subscription.this.subscription_id
}
