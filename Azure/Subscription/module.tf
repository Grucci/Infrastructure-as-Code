module "nova_subscription" {
    source                   = "./modules/subscription_azure"
    tenant_id                = "00000000-aaaa-bbbb-cccc-111111111111" # Escolhe o Tenant dinamicamente
    subscription_name        = "Sub-EA-Tenant-Dinamico"
    billing_account_name     = "1234567"
    enrollment_account_name  = "7654321"
    management_group_id      = "/providers/Microsoft.Management/managementGroups/MeuMG"
}