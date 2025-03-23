output "client_certificate" {
  value     = azurerm_kubernetes_cluster.example.kube_config[0].client_certificate
  sensitive = true
}

output "kube_config" {
  value     = azurerm_kubernetes_cluster.example.kube_config_raw
  sensitive = true
}

output "vm_public_ip" {
    value = azurerm_public_ip.infra-public-ip.ip_address
}

output "jenkins_disk_uri" {
  value = azurerm_managed_disk.jenkins_disk.id
}
