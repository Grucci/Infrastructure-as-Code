# provider "azurerm" {
#     features {}

#     alias = "subscription_target"
#     subscription_id = data.azurerm_subscription.target.id
#     tenant_id = "224559dc-f741-4f60-a3dc-80c5513755e5"
# }

terraform {
    required_providers {
        azurerm = {
            source  = "hashicorp/azurerm"
            version = ">= 3.0.0"
        }
    }
}

# Provider padrão — sempre precisa existir
provider "azurerm" {
    subscription_id = "27ef1f07-ab2f-47f7-b7f4-df091235184b"
    features {}
}

# Provider nomeado (alias) usado pelo seu código
provider "azurerm" {
    alias           = "subscription_target"
    subscription_id = "27ef1f07-ab2f-47f7-b7f4-df091235184b"

    resource_provider_registrations = "none"

    features {}
}