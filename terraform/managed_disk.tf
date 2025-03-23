resource "azurerm_managed_disk" "jenkins_disk" {
  name                 = "jenkins-disk"
  location             = azurerm_resource_group.rg-deploy.location
  resource_group_name  = azurerm_resource_group.rg-deploy.name
  disk_size_gb                 = 10 
  storage_account_type = "Standard_LRS"

  create_option = "Empty"

  tags = {
    Environment = "dev"
  }
}
