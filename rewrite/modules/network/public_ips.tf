resource "azurerm_public_ip" "jump_server_ip" {
 name                = "jump-server-ip"
 location            = var.rc-location
 resource_group_name = var.rc-name
 allocation_method   = "Dynamic"
 domain_name_label   = "${var.dns_name}"
 tags                = var.rc-tags
}


data "azurerm_public_ip" "jump_server_ip_data" {
 name                = azurerm_public_ip.jump_server_ip.name
 resource_group_name = var.rc-name
}