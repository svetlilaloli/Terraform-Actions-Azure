variable "storage_resource_group_name" {
  type        = string
  description = "azure storage resource group name"
}
variable "storage_account_name" {
  type        = string
  description = "azure storage account name"
}
variable "storage_account_tier" {
  type        = string
  description = "azure storage account tier"
}
variable "storage_account_replica_type" {
  type        = string
  description = "azure storage account replica type"
}
variable "storage_container_name" {
  type        = string
  description = "azure storage container name"
}
variable "app_resource_group_name" {
  type        = string
  description = "azure app resource group name"
}
variable "resource_group_location" {
  type        = string
  description = "azure localion"
}
variable "app_service_plan_name" {
  type        = string
  description = "azure app service plan name"
}
variable "app_service_name" {
  type        = string
  description = "app name"
}
variable "sql_server_name" {
  type        = string
  description = "sql server name"
}
variable "sql_database_name" {
  type        = string
  description = "database name"
}
variable "sql_admin_login" {
  type        = string
  description = "sql admin username"
}
variable "sql_admin_password" {
  type        = string
  description = "sql admin password"
}
variable "firewall_rule_name" {
  type        = string
  description = "sql firewall rule name"
}
variable "repo_url" {
  type        = string
  description = "public repo url"
}
