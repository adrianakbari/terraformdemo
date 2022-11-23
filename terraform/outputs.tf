output "resource_group_name" {
  value = azurerm_resource_group.rg.name
}

output "webvm1_private_ip_address" {
  value = azurerm_linux_virtual_machine.web_vm1.private_ip_address
}
output "gisvm1_private_ip_address" {
  value = azurerm_linux_virtual_machine.gis_vm1.private_ip_address
}
output "dbvm1_private_ip_address" {
  value = azurerm_linux_virtual_machine.db_vm1.private_ip_address
}

