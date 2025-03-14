# Create a Virtual Network (VNet) to define the address space for the resources.
# This network will span the entire project and allocate IP addresses within the range 10.0.0.0/16.

resource "azurerm_virtual_network" "infra-Net" {
    name                = "infraNet"
    address_space       = ["10.0.0.0/16"]  # Defines the network's address range.
    location            = azurerm_resource_group.rg-deploy.location
    resource_group_name = azurerm_resource_group.rg-deploy.name

    tags = {
        environment = "dev"  # Tagging the virtual network for 'dev' environment.
    }
}

# Create a Subnet within the previously created Virtual Network.
# This subnet will allocate IP addresses from the 10.0.1.0/24 range, segregating resources into this segment.

resource "azurerm_subnet" "infra-Subnet" {
    name                    = "infraSubnet"
    resource_group_name     = azurerm_resource_group.rg-deploy.name
    virtual_network_name    = azurerm_virtual_network.infra-Net.name
    address_prefixes        = ["10.0.1.0/24"]  # Subnet address range for segmentation.
}

# Create a Network Interface Card (NIC) that connects the virtual machine to the network.
# This NIC will have a static private IP (10.0.1.10) within the defined subnet and a dynamic public IP address.

resource "azurerm_network_interface" "vm-nic" {
    name                    = "vm-Nic"
    location                = azurerm_resource_group.rg-deploy.location
    resource_group_name     = azurerm_resource_group.rg-deploy.name

    ip_configuration {
        name                          = "vm-infra-ip"
        subnet_id                     = azurerm_subnet.infra-Subnet.id
        private_ip_address            = "10.0.1.10"  # Static private IP assigned to the NIC.
        private_ip_address_allocation = "Static"     # Static allocation of the private IP address.
        public_ip_address_id         = azurerm_public_ip.infra-public-ip.id  # Linking public IP.
    }

    tags = {
        environment = "dev"  # Tagging the NIC for 'dev' environment.
    }
}

# Create a Public IP address to allow external access to the virtual machine.
# The public IP will be dynamically allocated and attached to the network interface.

resource "azurerm_public_ip" "infra-public-ip" {
    name                     = "vm-public-ip"
    location                 = azurerm_resource_group.rg-deploy.location
    resource_group_name      = azurerm_resource_group.rg-deploy.name
    allocation_method        = "Dynamic"  # Dynamic allocation for the public IP address.
    sku                       = "Basic"    # Basic SKU for the public IP.

    tags = {
        environment = "dev"  # Tagging the public IP for 'dev' environment.
    }
}



# This resource creates a network interface (NIC) for each VM defined in the "vm_map" variable.
# It assigns a static private IP and links the NIC to a public IP address.
# The NIC is associated with the 'dev' environment tag for identification.
# The "for_each" loop iterates through the map of VMs, creating a unique NIC for each entry.


# resource "azurerm_network_interface" "vm-nic" {
#     for_each = var.vm_map

#     name                    = "${each.value.name}-nic"
#     location                = azurerm_resource_group.rg-deploy.location
#     resource_group_name     = azurerm_resource_group.rg-deploy.name

#     ip_configuration {
#         name                          = "vm-infra-ip"
#         subnet_id                     = azurerm_subnet.infra-Subnet.id
#         private_ip_address            = "10.0.1.10"  # Static private IP assigned to the NIC.
#         private_ip_address_allocation = "Static"     # Static allocation of the private IP address.
#         public_ip_address_id         = azurerm_public_ip.infra-public-ip.id  # Linking public IP.
#     }

#     tags = {
#         environment = "dev"  # Tagging the NIC for 'dev' environment.
#     }
# }