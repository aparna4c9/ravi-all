provider "azurerm" {
  version         = "1.38.0"
  subscription_id = var.susbcription_id
}

resource "azurerm_resource_group" "main" {
  name     = "${var.prefix}-resources"
  location = var.location
  tags     = var.tags
}

