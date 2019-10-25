variable "resource_group_name" {
  description = "The name of an existing resource group for the Managed Identity"
}

variable "keyvault_id" {
  description = "The id of an existing Key Vault for the Managed Identity to be granted access to"
}

variable "location" {
  description = "The Azure region of the Managed Identity"
}

variable "sz_environment" {
  description = "3 characters. Deployment environment. IE: dev, uat, prd"
}

variable "sz_application" {
  description = "6 char limit. Name of the application, product, or service"
}

variable "tags" {
  description = "A mapping of tags to assign to the resources"
  type        = "map"
  default     = {}
}
