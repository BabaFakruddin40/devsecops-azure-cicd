variable "location" {
  type        = string
  default     = "East US"
  description = "Azure region"
}

variable "resource_group_name" {
  type        = string
  default     = "devsecops-rg"
  description = "Name of the resource group"
}

variable "environment" {
  type        = string
  default     = "production"
  description = "Environment name"
}

variable "cluster_name" {
  type        = string
  default     = "devsecops-aks"
  description = "AKS cluster name"
}

variable "node_count" {
  type        = number
  default     = 2
  description = "Number of nodes in AKS"
}

variable "vm_size" {
  type        = string
  default     = "Standard_DS2_v2"
  description = "VM size for AKS nodes"
}

variable "acr_name" {
  type        = string
  default     = "devsecopsacr"
  description = "ACR name (must be globally unique)"
}

variable "ssh_public_key_path" {
  type        = string
  description = "Path to SSH public key"
  default     = "~/.ssh/id_rsa.pub"
}