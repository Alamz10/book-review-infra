
resource "azurerm_mysql_flexible_server" "mysql" {
  name                   = "${var.prefix}-server"
  resource_group_name    = var.resource_group_name
  location               = var.location
  administrator_login    = var.mysql_admin_username
  administrator_password = var.mysql_admin_password
  sku_name               = "22_04-lts-gen2"
}

resource "azurerm_mysql_flexible_database" "bookreview_db" {
  name                = "${var.prefix}-db"
  resource_group_name = var.resource_group_name
  server_name         = azurerm_mysql_flexible_server.mysql.name
  charset             = "utf8"
  collation           = "utf8_unicode_ci"
}

resource "azurerm_mysql_flexible_server_firewall_rule" "allow-backend-vm" {
  name                = "allow-backend-vm"
  resource_group_name = var.resource_group_name
  server_name         = azurerm_mysql_flexible_server.mysql.name
  start_ip_address    = var.backend_vm_public_ip
  end_ip_address      = var.backend_vm_public_ip
}