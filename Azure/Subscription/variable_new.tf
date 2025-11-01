variable "tenant_id" {
  description = "Tenant ID onde a subscription será criada"
  type        = string
}

variable "billing_account_name" {
  description = "Billing Account ID do contrato EA"
  type        = string
}

variable "enrollment_account_name" {
  description = "Enrollment Account Name do contrato EA"
  type        = string
}

variable "management_group_id" {
  description = "ID do Management Group para associação"
  type        = string
}

variable "subscription_name_map" {
  description = "Mapeamento de nomes de subscription por tenant"
  type        = map(string)
  default     = {
    "00000000-aaaa-bbbb-cccc-111111111111" = "Sub-EA-Tenant-Dinamico"
    "11111111-aaaa-bbbb-cccc-111111111111" = "Sub-EA-Tenant-Estatico"
  }
}

variable "subscription_tags_map" {
  description = "Mapeamento de tags por tenant"
  type        = map(map(string))
  default     = {
    "00000000-aaaa-bbbb-cccc-111111111111" = {
      "Owner"       = "Default"
      "Environment" = "Unknown"
    },
    "11111111-aaaa-bbbb-cccc-111111111111" = {
      "Owner"       = "Admin"
      "Environment" = "Production"
    }
  }
}