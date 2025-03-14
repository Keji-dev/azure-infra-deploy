resource "azurerm_linux_virtual_machine" "vm-dev-server" {
    # Define the virtual machine resource with the necessary configurations
    name = "vm-dev-server"  # Set the name of the VM
    resource_group_name = azurerm_resource_group.rg-deploy.name  # Associate with the resource group
    location = azurerm_resource_group.rg-deploy.location  # Define the location of the VM
    size = var.vm_size  # Use the VM size from the variable
    admin_username = "admin"  # Set the admin username
    network_interface_ids = [azurerm_network_interface.vm-nic.id]  # Attach the network interface
    disable_password_authentication = true  # Disable password authentication, using SSH keys instead

    admin_ssh_key {
      username = "admin"  # Define the SSH key username
      public_key = file("~/.ssh/id_rsa.pub")  # Path to the public SSH key for authentication
    }

    os_disk {
      caching = "ReadWrite"  # Set disk caching mode
      storage_account_type = "Standard_LRS"  # Set storage type for the OS disk
    }

    source_image_reference {
      publisher = "Canonical"  # Use Ubuntu image from Canonical
      offer = "ubuntu-24_04-lts"  # Specify the Ubuntu version
      sku = "server"  # Set the SKU for the Ubuntu image
      version = "latest"  # Use the latest available version
    }

    boot_diagnostics {
      storage_account_uri = azurerm_storage_account.stAccount.primary_blob_endpoint  # Set the storage account for boot diagnostics
    }

    tags = {
        environment = "dev"  # Tag to indicate this VM is for development
    }
}


# The "azurerm_linux_virtual_machine" resource creates a VM for each entry in the "vm_map".
# The "for_each" loop iterates over the map, creating one VM per entry. The name and size of the VM are defined using values from the map.
# It also associates a network interface, uses SSH key authentication, and sets up the OS disk and source image (Ubuntu 24.04 LTS).
# Boot diagnostics are enabled to store logs in a storage account, and the VMs are tagged as "dev" for development.

# resource "azurerm_linux_virtual_machine" "vm-dev-server" {
#     # Define the virtual machine resource with the necessary configurations
#     for_each = var.vm_map

#     name = each.value.name  # Set the name of the VM per each key
#     resource_group_name = azurerm_resource_group.rg-deploy.name  # Associate with the resource group
#     location = azurerm_resource_group.rg-deploy.location  # Define the location of the VM
#     size = each.value.size # Use the VM size from the variable per each key
#     admin_username = "admin"  # Set the admin username
#     network_interface_ids = [azurerm_network_interface.vm-nic[each.key].id]  # Attach the network interface per each key
#     disable_password_authentication = true  # Disable password authentication, using SSH keys instead

#     admin_ssh_key {
#       username = "admin"  # Define the SSH key username
#       public_key = file("~/.ssh/id_rsa.pub")  # Path to the public SSH key for authentication
#     }

#     os_disk {
#       caching = "ReadWrite"  # Set disk caching mode
#       storage_account_type = "Standard_LRS"  # Set storage type for the OS disk
#     }

#     source_image_reference {
#       publisher = "Canonical"  # Use Ubuntu image from Canonical
#       offer = "ubuntu-24_04-lts"  # Specify the Ubuntu version
#       sku = "server"  # Set the SKU for the Ubuntu image
#       version = "latest"  # Use the latest available version
#     }

#     boot_diagnostics {
#       storage_account_uri = azurerm_storage_account.stAccount.primary_blob_endpoint  # Set the storage account for boot diagnostics
#     }

#     tags = {
#         environment = "dev"  # Tag to indicate this VM is for development
#     }
# }