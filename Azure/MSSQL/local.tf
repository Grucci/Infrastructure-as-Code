locals {
    today = timestamp()

    # CMK Expiration 1 year --> 8760
    keyvault_secret_expiration = timeadd(local.today, "${var.mssql_key_secrets.secret_expiration}h")

    ami_id = data.azurerm_user_assigned_identity.this.principal_ids

    kv_policies = data.azurerm_key_vault.key_vault_encryption.access_policy

    needed_permissions = ["Get", "WrapKey", "UnWrapKey"]
    actual_permissions = [for objects in local.kv_policies : objects.key_permissions if objects.object_id == local.ami_id]

    ami_has_cmk_permission = alltrue([for permission in local.needed_permissions : contains(local.actual_permissions[0], permission)])
}