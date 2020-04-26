terraform {
  backend "azurerm" {
    resource_group_name  = "TF_RemoteState"
    storage_account_name = "xyzclientremotestate"
    container_name       = "remotestate"
    key                  = "terraform.tfstate"
  }
}


data "terraform_remote_state" "azurerm" {
  backend = "azurerm"
  config = {
    storage_account_name = "xyzclientremotestate"
    container_name       = "remotestate"
    key                  = "terraform.tfstate"
    sas_token =var.remotestate_sas
  }
}
