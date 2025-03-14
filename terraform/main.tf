# Resource group to organize and manage all the infrastructure resources.  
# This group will contain all resources deployed for the project.  

resource "azurerm_resource_group" "rg-deploy" {
    name = "rg-azure-infra-deploy"
    location = var.location

    tags = {
        environment = "dev"
    }
}

# Create a storage account within the resource group to store project data.  
# This account will use Standard performance tier and LRS replication for durability.  

resource "azurerm_storage_account" "stAccount" {
    name = "storage_account_azure_infra"
    resource_group_name = azurerm_resource_group.rg-deploy.name
    location = azurerm_resource_group.rg-deploy.location
    account_tier = "Standard" # Performance tier (Standard or Premium)
    account_replication_type = "LRS" # Locally Redundant Storage (LRS) for data redundancy

    tags = {
        environment = "dev"
    }
}