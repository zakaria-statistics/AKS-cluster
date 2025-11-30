variable "subscription_id" {
  description = "Azure subscription ID"
  type        = string
}

variable "client_id" {
  description = "Service principal client ID (appId)"
  type        = string
}

variable "client_secret" {
  description = "Service principal client secret (password)"
  type        = string
  sensitive   = true
}

variable "tenant_id" {
  description = "Azure AD tenant ID"
  type        = string
}

variable "location" {
  description = "Azure region for AKS and RG"
  type        = string
  default     = "francecentral"
}

variable "resource_group_name" {
  description = "Name of the resource group"
  type        = string
  default     = "rg-aks-bootstrap"
}

variable "aks_name" {
  description = "AKS cluster name"
  type        = string
  default     = "aks-bootstrap"
}

variable "dns_prefix" {
  description = "DNS prefix for the AKS API server"
  type        = string
  default     = "aksbootstrap"
}

variable "node_count" {
  description = "Initial node count"
  type        = number
  default     = 1
}

variable "node_vm_size" {
  description = "VM size for AKS nodes"
  type        = string
  default     = "Standard_B2s"
}

# Toggle monitoring to save $ (set false to skip Log Analytics)
variable "enable_monitoring" {
  description = "Enable container insights"
  type        = bool
  default     = false
}


variable "vnet_cidr" {
  description = "CIDR for AKS VNet"
  type        = string
  default     = "10.10.0.0/16"
}

variable "aks_subnet_cidr" {
  description = "CIDR for AKS subnet"
  type        = string
  default     = "10.10.1.0/24"
}

variable "admin_username" {
  description = "Linux admin user for AKS nodes"
  type        = string
  default     = "aksadmin"
}

variable "ssh_public_key" {
  description = "SSH public key for node access"
  type        = string
}

# Tags
variable "tags" {
  description = "Common tags"
  type        = map(string)
  default = {
    environment = "lab"
    cost_center = "low"
    owner       = "zak"
  }
}
