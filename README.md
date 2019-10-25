# Managed Identity Module

## Synopsis

This module creates a [user-assigned Managed Identity](https://docs.microsoft.com/en-us/azure/active-directory/managed-identities-azure-resources/overview).

## Example usage

Calling the ManagedIdentity module:

``` (hcl)
module "managed-identity" {
  source = "../ManagedIdentity"

  name                = "${var.sz_application}-${var.sz_environment}-mi"
  tenant_id           = "${var.tenant_id}"
  subscription_id     = "${var.subscription_id}"
  resource_group_name = "${azurerm_resource_group.spoke-rg.name}"
  keyvault_id        = "${module.keyvault.kv_id}"
  location            = "${var.location}"
  sz_environment      = "${var.sz_environment}"
  sz_application      = "${var.sz_application}"
  tags                = "${var.tags}"
}
```

Adding a Managed Identity created by the module to a Virtual Machine:

``` (hcl)
resource "azurerm_virtual_machine" "cfg" {
  provider              = azurerm.spoke
  name                  = "${var.sz_application}-cfg-vm"
  location              = "${var.location}"
  ...
  identity {
    type = "UserAssigned"
    identity_ids = ["${module.spoke-module.spoke_mi_id}"]
  }
  ...
  os_profile_windows_config {}
  tags = local.tags
}
```

## Inputs

| Input Variable | Description |
|--|--|
| `name` | The name of the Managed Identity |
| `tenant_id` | The id of the Sub-Zero tenant |
| `subscription_id` | The id of the Subscription where the Managed Identity is scoped |
| `resource_group_name` | The name of an existing resource group for the Managed Identity |
| `keyvault_id` | The id of an existing Key Vault for the Managed Identity to be granted access to |
| `sz_application` | 6 char limit. Name of the application, product, or service |
| `sz_environment` | 3 characters. Deployment environment. IE: dev, uat, prd |
| `location` | The Azure region of the Resource Group. Locations approved by policy are: `northcentralus`, `centralus` |
| `tags` | A mapping of tags to assign to the resources. Pass in `local.tags` as in the `example/main.tf` |

## Outputs

| Output Variable | Source | Description |
|--|--|--|
| `mi_id` | `azurerm_user_assigned_identity.mgd_id.id` | ID of the Managed Identity |
| `mi_principal_id` | `azurerm_user_assigned_identity.mgd_id.principal_id` | Service Principal ID of the associated Managed Identy |
| `mi_client_id` | `azurerm_user_assigned_identity.mgd_id.client_id` | Client ID of the associated Managed Identy |

## Guardrails

| Name | Description | Details | Status |
|--|--|--|--|
| Naming and tagging standards | Enforces standards for naming and tagging resources | [Standards](https://dev.azure.com/SubZeroGroupInc/Project%20Helios/_git/infra-modules?path=%2FSubscription&version=GBdev&_a=readme) |  Not implemented |