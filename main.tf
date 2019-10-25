data "azurerm_client_config" "current" {}

resource "azurerm_user_assigned_identity" "mgd_id" {
  name                = "${var.sz_application}-${var.sz_environment}-mi"
  location            = "${var.location}"
  resource_group_name = "${var.resource_group_name}"
  tags                = "${var.tags}"
}

resource "azurerm_role_definition" "role_def" {
  name        = "${var.sz_application}-${var.sz_environment}-mi-rd"
  scope       = "/subscriptions/${data.azurerm_client_config.current.subscription_id}"
  description = "This is a custom role created via Terraform for Managed Identity ${var.sz_application}-${var.sz_environment}-mi"

  permissions {
    actions     = ["*/read"]
    not_actions = []
  }

  assignable_scopes = [
    "/subscriptions/${data.azurerm_client_config.current.subscription_id}",
  ]
}

resource "azurerm_role_assignment" "role_asn" {
  scope              = "/subscriptions/${data.azurerm_client_config.current.subscription_id}"
  role_definition_id = "${azurerm_role_definition.role_def.id}"
  principal_id       = "${azurerm_user_assigned_identity.mgd_id.principal_id}"
}

resource "azurerm_key_vault_access_policy" "kv_policy" {
  key_vault_id = "${var.keyvault_id}"
  tenant_id    = "${data.azurerm_client_config.current.tenant_id}"
  object_id    = "${azurerm_user_assigned_identity.mgd_id.principal_id}"

  key_permissions = [
    "get",
  ]

  secret_permissions = [
    "get",
  ]
}
