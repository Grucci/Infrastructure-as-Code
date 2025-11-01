terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "3.105.0"
    }
  }
}

provider "azurerm" {
  skip_provider_registration = true
  features {}
}

data "azurerm_subscription" "azure_subscription" {
}

## Get the list of Policies
data "azurerm_policy_definition" "custom_policies_definitions" {
  count        = length(var.policies_definitions_list)
  display_name = var.policies_definitions_list[count.index]

  depends_on = [
    azurerm_policy_definition.logicappdenyha, 
    azurerm_policy_definition.logicappauditha, 
    azurerm_policy_definition.logicappdisableha
  ]
}

# data "azurerm_policy_set_definition" "custom_policies_set_definitions" {
#   #display_name = "[WAF] Test Initiative"
#   count        = length(var.policiesset_definitions_list)
#   display_name = var.policiesset_definitions_list[count.index]


#   depends_on = [
#     azurerm_policy_set_definition.logicappdenyha_polset
#   ]
# }

## Policy Definition
resource "azurerm_policy_definition" "logicappdenyha" {
  name         = var.policy_name
  display_name = var.policy_display_name
  description  = var.policy_description
  mode         = var.policy_mode
  policy_type  = var.policy_type

  lifecycle {
    ignore_changes = [metadata]
}
  metadata = file("${path.module}/LogicAppDenyHA/metadata.json")
  policy_rule = file("${path.module}/LogicAppDenyHA/policyRule.json")
  parameters = file("${path.module}/LogicAppDenyHA/parameters.json")
}


resource "azurerm_policy_definition" "logicappauditha" {
  name         = var.policy_namev2
  display_name = var.policy_display_namev2
  description  = var.policy_descriptionv2
  mode         = var.policy_modev2
  policy_type  = var.policy_typev2

  lifecycle {
    ignore_changes = [metadata]
}
  metadata = file("${path.module}/LogicAppAuditHA/metadata.json")
  policy_rule = file("${path.module}/LogicAppAuditHA/policyRule.json")
  parameters = file("${path.module}/LogicAppAuditHA/parameters.json")
}

resource "azurerm_policy_definition" "logicappdisableha" {
  name         = var.policy_namev3
  display_name = var.policy_display_namev3
  description  = var.policy_descriptionv3
  mode         = var.policy_modev3
  policy_type  = var.policy_typev3

  lifecycle {
    ignore_changes = [metadata]
}
  metadata = file("${path.module}/LogicAppDisableHA/metadata.json")
  policy_rule = file("${path.module}/LogicAppDisableHA/policyRule.json")
  parameters = file("${path.module}/LogicAppDisableHA/parameters.json")
}

resource "azurerm_policy_set_definition" "logicappdenyha_polset" {
  name         = "[WAF] Test Initiative"
  policy_type  = "Custom"
  display_name = "[WAF] Test Initiative"
  description  = "[WAF] Test Initiative"
  metadata = <<METADATA
    {
    "category": "${var.policyset_definition_category}"
    }
METADATA

  dynamic "policy_definition_reference" {
    for_each = data.azurerm_policy_definition.custom_policies_definitions
    content {
      policy_definition_id = policy_definition_reference.value["id"]
      reference_id         = policy_definition_reference.value["id"]
      # parameters           = var.custom_initiative_parameters["id"] (ANALISAR)
    }
  }

  depends_on = [
    data.azurerm_policy_definition.custom_policies_definitions
  ]
}

# resource "azurerm_subscription_policy_assignment" "wafpolset" {
#   name                 = "Azure Assign Initiative"
#   policy_definition_id = var.initiative_assign_id
#   #policy_definition_id = data.azurerm_policy_set_definition.custom_policies_set_definitions[count.index]
#   subscription_id      = data.azurerm_subscription.azure_subscription.id

#   depends_on = [
#     azurerm_policy_set_definition.logicappdenyha_polset
#   ]
# }

# resource "azurerm_subscription_policy_assignment" "wafpolset" {
#   name                 = "Azure Assign Initiative"
# #  policy_definition_id = data.azurerm_policy_set_definition.custom_policies_set_definitions.id
#   subscription_id      = data.azurerm_subscription.azure_subscription.id

#   dynamic "policy_set_definition_reference" {
#     for_each = data.azurerm_policy_set_definition.custom_policies_set_definitions
#     content {
#       policy_definition_id = policy_set_definition_reference.value["id"]
#       reference_id         = policy_set_definition_reference.value["id"]
#     }
#   }

#   depends_on = [
#     data.azurerm_policy_set_definition.custom_policies_set_definitions
#   ]
# }