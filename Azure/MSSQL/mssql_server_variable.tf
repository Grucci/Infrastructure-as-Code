variable "tags" {
    description = "Tags to be applied to the resources"
    type        = map(string)
    default     = {}

}

variable "mssql_foundation" {
    description = <<EOF
    ** Foundation Configuration for MSSQL Server **

    ** location: The Azure region where the MSSQL Server will be deployed.
    ** environment: The environment for which the MSSQL Server is being configured (e.g., dev, prod).

EOF
    type        = object({
        environment = string
        location  = string
    })
}

variable "mssql_server" {
    description = <<EOF
    ** MSSQL Server Configuration

    ** name: The name of the MSSQL Server.
    ** resource_group_name: The name of the resource group where the MSSQL Server will be deployed.
    ** version: The version of the MSSQL Server (e.g., "12.0", "13.0", "14.0").
    ** administrator_login: The administrator login name for the MSSQL Server.
    ** administrator_login_password: The password for the administrator login.
    ** minimum_tls_version: The minimum TLS version supported by the MSSQL Server (e.g, "1.2").
    ** provider: The provider for the MSSQL Server (e.g., "Microsoft.Sql").
    ** connection_policy: The connection policy for the MSSQL Server (e.g., "Default", "Proxy").
    ** public_network_access_enabled: Whether public network access is enabled for the MSSQL Server.
    ** transparent_data_encryption_key_vault_key_id: The Key Vault key ID for transparent data encryption.
    ** Note: The administrator_login_password should be stored securely, such as in Azure Key Vault.
    **       It is recommended to use a random password generator for security.

    EOF
    type        = object({
        name                          = string
        resource_group_name           = string
        version                       = string
        administrator_login           = string
        administrator_login_password  = string
        minimum_tls_version           = string
        provider                      = string
        connection_policy             = optional(string, "Default")
        public_network_access_enabled = optional(bool, true)
        transparent_data_encryption_key_vault_key_id = optional(string, null)
    })
}

variable "mssql_identity" {
    description = <<EOF
    ** Identity Configuration for MSSQL Server **

    ** type: The type of identity to be used (e.g., "SystemAssigned", "UserAssigned").
    ** primary_user_assigned_identity_id: The ID of the primary user-assigned identity.
    ** Note: If using UserAssigned identity, ensure the identity exists in the specified resource group.

    EOF
    type        = object({
        type                              = string
        primary_user_assigned_identity_id = optional(string, null)
    })
}

variable "mssql_administrator" {
    description = <<EOF
    ** MSSQL Administrator Configuration

    ** login_username: The username for the MSSQL administrator.
    ** Note: Ensure that the username is unique and follows Azure naming conventions.

    EOF
    type        = object({
        login_username = string
        object_id      = optional(string, null)
    })
}

variable "mssql_network" {
    description = <<EOF
    ** MSSQL Network Configuration

    ** public_network_access_enabled: Whether public network access is enabled for the MSSQL Server.
    ** Note: If set to false, ensure that private endpoints are configured for secure access.

    EOF
    type        = object({
        public_network_access_enabled = optional(bool, true)
        private_dns_zone_id           = optional(string, null)
        subnet_id                     = optional(string, null)
    })
}

variable "mssql_key_vault" {
    description = <<EOF
    ** MSSQL Key Vault Configuration

    ** key_vault_id: The ID of the Key Vault used for storing secrets.
    ** Note: Ensure that the Key Vault has the necessary permissions for the MSSQL Server.

    EOF
    type        = object({
        key_vault_id = string
    })
}

variable "mssql_role_assignment" {
    description = <<EOF
    ** MSSQL Role Assignment Configuration

    ** role_definition_name: The name of the role definition to be assigned (e.g., "Contributor", "Reader").
    ** principal_id: The ID of the principal (user, group, or service principal) to which the role is assigned.
    ** Note: Ensure that the principal has the necessary permissions for the MSSQL Server.

    EOF
    type        = object({
        role_definition_name = string
        principal_id         = string
    })
}

variable "mssql_auditoria" {
    description = <<EOF
    ** MSSQL Auditoria Configuration

    ** retention_in_days: The number of days to retain audit logs.
    ** log_analytics_workspace_id: The ID of the Log Analytics workspace for monitoring.
    ** Note: Ensure that the storage account is configured for auditing and has the necessary permissions.
    ** Note: Ensure that the storage account has the necessary permissions for storing audit logs.

    EOF
    type        = object({
        retention_in_days           = optional(number, 90)
        log_analytics_workspace_id  = optional(string, "Enabled")
    })
}