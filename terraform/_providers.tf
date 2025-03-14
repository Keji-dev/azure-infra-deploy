# Declare the required providers for Azure and GitHub to manage infrastructure resources.
# Azure provider is used for creating and managing resources in Azure.  
# GitHub provider is used to interact with GitHub repositories.  

terraform {
  required_providers {
    github = {
      source  = "integrations/github"
      version = "~> 6.0"
    }

    azurerm = {
        source = "hashicorp/azurerm"
        version = "4.23.0"
    }
  }
}

# Configure GitHub provider using the personal access token stored in the variable.  
# This is required to create and manage a GitHub repository.  

provider "github" {
  token = var.github_token
}
