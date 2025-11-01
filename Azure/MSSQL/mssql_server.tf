# ------------------- Key Vault Secrets for MSSQL Server -------------------
resource "azurerm_key_vault_secret" "adm_user" {
    name            = "mssql-${var.mssql_foundation.environment}-adm-user"
    value           = var.mssql_administrator.login_username
    key_vault_id    = var.mssql_server.key_vault_id
    expiration_date = local.keyvault_secret_expiration
    content_type    = "text/plain"
    tags            = var.tags
}

resource "random_password" "admin_user" {
    length  = 20
    special = true
    override_special = "_@"
}

resource "azurerm_key_vault_secret" "admin_pwd" {
    name            = "mssql-${var.mssql_foundation.environment}-adm-pwd"
    value           = random_password.admin_user.result
    key_vault_id    = var.mssql_server.key_vault_id
    expiration_date = local.keyvault_secret_expiration
    content_type    = "text/plain"
    tags            = var.tags
}

resource "random_password" "admin_pwd" {
    length  = 30
    special = true
    override_special = "_@"
}

# ------------------- MSSQL Server -------------------
resource "azurerm_mssql_server" "example" {
    lifecycle {
        precondition {
            condition = local.ami_has_cmk_permission
            error_message = "The user does not have permission to Get, WrapKey, UnWrapKey in KeyVault."
        }
    }
    name = "mssql${var.mssql_foundation.environment}${var.mssql_server.name}"
    resource_group_name                          = var.mssql_server.resource_group_name
    location                                     = var.mssql_foundation.location
    version                                      = var.mssql_server.version
    administrator_login                          = var.mssql_server.administrator_login
    administrator_login_password                 = var.mssql_server.administrator_login_password
    minimum_tls_version                          = var.mssql_server.minimum_tls_version
    provider                                     = var.mssql_server.provider
    connection_policy                            = var.mssql_server.connection_policy
    public_network_access_enabled                = var.mssql_network.public_network_access_enabled
    primary_user_assigned_identity_id            = var.mssql_identity.primary_user_assigned_identity_id
    transparent_data_encryption_key_vault_key_id = var.mssql_server.transparent_data_encryption_key_vault_key_id
    tags                                         = var.tags

    identity {
        type         = var.mssql_identity.type
        identity_ids = [var.mssql_identity.primary_user_assigned_identity_id]
    }

    azuread_administrator {
        login_username = var.mssql_administrator.login_username
        object_id      = var.mssql_administrator.object_id
    }

    depends_on = [ azurerm_key_vault_secret.adm_user, azurerm_key_vault_secret.admin_pwd ]
}

# ------------------- MSSQL Private Endpoint Configuration -------------------
resource "azurerm_private_endpoint" "pvt_mssql" {
    name                = "mssql-${var.mssql_foundation.environment}-pvt-endpoint"
    location            = var.mssql_foundation.location
    resource_group_name = var.mssql_server.resource_group_name
    subnet_id           = var.mssql_network.subnet_id
    provider            = azurerm
    tags                = var.tags

    private_service_connection {
        name                           = "mssql-${var.mssql_foundation.environment}-psc"
        is_manual_connection           = false
        private_connection_resource_id = azurerm_mssql_server.example.id
        subresource_names              = ["sqlServer"]
    } 

    lifecycle {
        ignore_changes = [
            private_dns_zone_group,
            subnet_id]
    }

    private_dns_zone_group {
        name                 = "mssql-${var.mssql_foundation.environment}-pdzg"
        private_dns_zone_ids = [var.mssql_network.private_dns_zone_id]
    }
}

# ------------------- MSSQL Role Assignment -------------------
resource "azurerm_role_assignment" "example" {
    scope                = azurerm_mssql_server.example.id
    role_definition_name = var.mssql_role_assignment.role_definition_name
    principal_id         = var.mssql_role_assignment.principal_id

    depends_on = [azurerm_private_endpoint.pvt_mssql]
}

# ------------------- MSSQL Auditing Policy -------------------
resource "azurerm_mssql_server_extended_auditing_policy" "example" {
    server_id              = azurerm_mssql_server.example.id
    log_monitoring_enabled = azurerm_mssql_server.example.id
    provider               = azurerm
    retention_in_days      = var.mssql_auditoria.retention_in_days
    
    depends_on = [ azure_mssql_server.example ]
}

# ------------------- MSSQL Auditing Policy Repository -------------------
resource "azurerm_monitor_diagnostic_setting" "example" {
    name                       = "mssql-${var.mssql_foundation.environment}-diagnostic-setting"
    target_resource_id         = "${azurerm_mssql_server.example.id}/database/master"
    provider                   = azurerm
    log_analytics_workspace_id = var.mssql_auditoria.log_analytics_workspace_id

    enabled_log {
        category = "SQLSecurityAuditEvents"
    }

    enabled_metric {
        category = "AllMetrics"
    }

    lifecycle {
        ignore_changes = [
            log_analytics_workspace_id,
            target_resource_id
        ]
    }
    depends_on = [azurerm_mssql_server.example]
}