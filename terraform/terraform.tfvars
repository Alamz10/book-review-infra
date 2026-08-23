location = "East US"


application_name = "DevOps1-pm"
environment      = "dev"

prefix = "book-review"
# Networking Configuration
vnet_address_space             = ["10.0.0.0/16"]
public_subnet_address_prefixes = ["10.0.1.0/24"]

# Virtual Machine Configuration
admin_username = "alamz"
admin_password = "youareMad@!"

# Database Configuration
mysql_admin_username = "mysqladmin"
mysql_admin_password = "YourSecureMySQLPassword123!"
mysql_database_name  = "bookreviews_dev"