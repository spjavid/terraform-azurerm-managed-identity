output "mi_id" {
  value = "${azurerm_user_assigned_identity.mgd_id.id}"
}

output "mi_principal_id" {
  value = "${azurerm_user_assigned_identity.mgd_id.principal_id}"
}

output "mi_client_id" {
  value = "${azurerm_user_assigned_identity.mgd_id.client_id}"
}
