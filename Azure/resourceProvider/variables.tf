variable "azurerm_resource_provider_name" {
    description = "Lista de nomes dos provedores de recursos do Azure a serem registrados na subscription."
    type        = list(string)
}

variable "azurerm_rp_feature_name" {
    description = "Nome do recurso de provedor a ser registrado."
    type        = string
}

variable "azurerm_feature_feature_name" {
    description = "Nome do recurso de recurso a ser registrado."
    type        = string
}

variable "feature_registered" {
    description = "Indica se o recurso de recurso está registrado."
    type        = bool
    default     = true
}

variable "register_resource_providers" {
    description = "Indica se os provedores de recursos devem ser registrados."
    type        = bool
    default     = true
}

variable "register_feature" {
    description = "Indica se o recurso de recurso deve ser registrado."
    type        = bool
    default     = true
}

variable "subscription_name" {
    description = "Nome da assinatura do Azure."
    type        = string
}