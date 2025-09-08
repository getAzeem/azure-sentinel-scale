variable "prefix" {
  type        = string
  description = "The prefix which should be used for all resources"
  default     = "vmss"
}

variable "location" {
  type        = string
  description = "The Azure Region in which all resources should be created"
  default     = "East US"
}

variable "vm_sku" {
  type        = string
  description = "The VM Size for the Scale Set instances"
  default     = "Standard_B1s"
}

variable "instance_count" {
  type        = number
  description = "The number of VM instances"
  default     = 2
}

variable "admin_username" {
  type        = string
  description = "Admin username for the VMs"
  default     = "azureuser"
}

variable "admin_password" {
  type        = string
  description = "Admin password for the VMs"
  sensitive   = true
  # Note: This variable has no default, so Terraform will prompt for a value at runtime.
}

variable "application_port" {
  type        = number
  description = "The port that the web application listens on"
  default     = 80
}
