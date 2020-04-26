variable "virtual_machine_name" {
}

variable "location" {
}

variable "admin_username" {
}

# variable "admin_password" {}
variable "prefix" {
}

variable "susbcription_id" {
}

variable "vnet_cidr_block" {
  description = "CIDR block for the VNET"
  default     = ["10.0.0.0/16"]
}

variable "frontend_subnet_cidr" {
  description = "CIDR block for Frontend Subnet"
  default     = ""
}

variable "vm_size" {
  description = "Size of the VM viz., B1s"
  default     = "Standard_B1s"
}

variable "node_count" {
  description = "Number of VMs required"
  default     = 1
}

variable "tags" {
  type = map(string)

  default = {
    Name = "mywebapp"
  }

  description = "Any tags which should be assigned to the resources in this example"
}

variable "remotestate_sas" {

  description = "This will be your sas token for Remote state container"
  
}
