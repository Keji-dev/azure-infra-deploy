# GitHub Personal Access Token. Used for authenticating the GitHub provider in Terraform to manage repositories.  
# Marked as 'sensitive' to avoid displaying the value in Terraform output.  

variable "github_token" {
  description = "GitHub Personal Access Token"
  sensitive   = true
}

# Azure region where resources will be deployed. Default is "West Europe", but can be adjusted as needed.  

variable "location" {
  description = "Azure Region"
  default = "West Europe"
}

# VM size defining the computing power (CPU/RAM). Default is "Standard_D1_V2", but can be changed as needed.  

variable "vm_size" {
  description = "VM size/computing"
  default = "Standard_D1_V2"
}


# The "vm_map" variable is a map that defines the configuration for each virtual machine (VM). 
# Each entry in the map contains the name and size of a VM. This allows for dynamic VM creation with different configurations.

# variable "vm_map" {
#   type = map(object({
#     name = string
#     size = string
#   }))

#   default = {
#     "vm-dev-server1" = {
#       name = "vm-dev-server1"
#       size = "Standard_B2s"
#     }

#     "vm-dev-server2" = {
#       name = "vm-dev-server2"
#       size = "Standard_B1s"
#     }

#     "vm-dev-server3" = {
#       name = "vm-dev-server3"
#       size = "Standard_D2s_v3"
#     }
#   }
# }