# policy_definition_category = "Custom"

## Deny Logic App without HA variables
policy_name           = "logicAppDenyHA"
policy_display_name   = "Deny Logic Apps Without High Availability"
policy_description    = "Test DENY Deployment of Logic Apps Without High Availability"
policy_mode           = "Indexed"
policy_type           = "Custom"

## Audit Logic App without HA variables
policy_namev2         = "logicAppAuditHA"
policy_display_namev2 = "Audit Logic Apps Without High Availability"
policy_descriptionv2  = "Test AUDIT Deployment of Logic Apps Without High Availability"
policy_modev2         = "Indexed"
policy_typev2         = "Custom"

## Disabled Logic App without HA variables
policy_namev3         = "logicAppDisableHA"
policy_display_namev3 = "Disable Logic Apps Without High Availability"
policy_descriptionv3  = "Test DISABLE Deployment of Logic Apps Without High Availability"
policy_modev3         = "Indexed"
policy_typev3         = "Custom"

policies_definitions_list = [
        "Deny Logic Apps Without High Availability",
        "Audit Logic Apps Without High Availability",
        "Disable Logic Apps Without High Availability"
]

initiative_assign_id = "[WAF] Test Initiative"

# policiesset_definitions_list = [
#         "[waf] test initiative"
# ]
