# Create a Network Security Group (NSG) to control inbound and outbound traffic to resources in the network.
# This NSG will allow SSH traffic on port 22, which is commonly used for remote access to virtual machines.

resource "azurerm_network_security_group" "infra-sec-group" {
    name                     = "ssh-traffic"  # Name of the security group to allow SSH access.
    location                 = azurerm_resource_group.rg-deploy.location
    resource_group_name      = azurerm_resource_group.rg-deploy.name

    # Define security rule to allow SSH access on port 22.
    security_rule = {
        name                        = "SSH"  # Rule name for SSH access.
        priority                    = 1001  # Priority to determine rule application order (lower is higher priority).
        direction                   = "Inbound"  # The rule applies to inbound traffic.
        access                      = "Allow"  # Allow traffic matching the rule.
        protocol                    = "Tcp"  # Specifies the TCP protocol for SSH.
        source_port_range           = "*"  # Any source port is allowed.
        destination_port_range      = "22"  # Allow traffic on port 22 (SSH).
        source_address_prefix       = "*"  # Allow traffic from any source address.
        destination_address_prefix  = "*"  # Allow traffic to any destination address.
    }

    tags = {
        environment = "dev"  # Tagging the NSG for 'dev' environment.
    }
}

# Associate the created Network Security Group with the Network Interface to enforce the security rules on the NIC.

resource "azurerm_network_interface_security_group_association" "infra-sec-group-association" {
    network_interface_id        = azurerm_network_interface.infra-Nic.id  # Associate NSG with the NIC.
    network_security_group_id   = azurerm_network_security_group.infra-sec-group.id  # Link to the NSG created earlier.
}
