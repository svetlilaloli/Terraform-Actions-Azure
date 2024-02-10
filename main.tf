terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "=3.89.0"
    }
  }

  backend "azurerm" {
    resource_group_name  = "StorageRG"
    storage_account_name = "mytaskboardstorage"
    container_name       = "taskboardcontainer"
    key                  = "terraform.tfstate"
  }
}

provider "azurerm" {
  features {}
}
# generate random integer
resource "random_integer" "ri" {
  min = 10000
  max = 99999
}
resource "azurerm_resource_group" "rg" {
  name     = "${var.resource_group_name}-${random_integer.ri.result}"
  location = var.resource_group_location
}
# create Linux app service plan
resource "azurerm_service_plan" "sp" {
  name                = "${var.app_service_plan_name}-${random_integer.ri.result}"
  resource_group_name = azurerm_resource_group.rg.name
  location            = azurerm_resource_group.rg.location
  os_type             = "Linux"
  sku_name            = "F1"
}
# create web app, pass app service plan ID
resource "azurerm_linux_web_app" "lwa" {
  name                = "${var.app_service_name}-${random_integer.ri.result}"
  resource_group_name = azurerm_resource_group.rg.name
  location            = azurerm_service_plan.sp.location
  service_plan_id     = azurerm_service_plan.sp.id
  connection_string {
    name  = "DefaultConnection"
    type  = "SQLAzure"
    value = "Data Source=tcp:${azurerm_mssql_server.mssqlsrvr.fully_qualified_domain_name},1433;Initial Catalog=${azurerm_mssql_database.db.name};User ID=${azurerm_mssql_server.mssqlsrvr.administrator_login};Password=${azurerm_mssql_server.mssqlsrvr.administrator_login_password};Trusted_Connection=False; MultipleActiveResultSets=True;"
  }
  site_config {
    application_stack {
      dotnet_version = "6.0"
    }
    always_on = false
  }
}

resource "azurerm_mssql_server" "mssqlsrvr" {
  name                         = "${var.sql_server_name}-${random_integer.ri.result}"
  resource_group_name          = azurerm_resource_group.rg.name
  location                     = azurerm_resource_group.rg.location
  version                      = "12.0"
  administrator_login          = var.sql_admin_login
  administrator_login_password = var.sql_admin_password
}

resource "azurerm_mssql_database" "db" {
  name           = "${var.sql_database_name}-${random_integer.ri.result}"
  server_id      = azurerm_mssql_server.mssqlsrvr.id
  collation      = "SQL_Latin1_General_CP1_CI_AS"
  license_type   = "LicenseIncluded"
  max_size_gb    = 2
  sku_name       = "S0"
  zone_redundant = false
}

resource "azurerm_mssql_firewall_rule" "firewall" {
  name             = var.firewall_rule_name
  server_id        = azurerm_mssql_server.mssqlsrvr.id
  start_ip_address = "0.0.0.0"
  end_ip_address   = "0.0.0.0"
}
# deploy code from public GitHub repo
resource "azurerm_app_service_source_control" "sc" {
  app_id                 = azurerm_linux_web_app.lwa.id
  repo_url               = var.repo_url
  branch                 = "main"
  use_manual_integration = true
}
