# general variables
variable "region" {
  type        = string
}
variable "project_id" {
  type        = string
}
variable "region_location" {
  type        = string
}
variable "global_region" {
  type        = string
}
variable "vpc_name" {
  type        = string
}

# outputs variables
variable "output_vpc_id" {
  type        = string
}
variable "output_service_private_access" {
}

# Cloud SQL  variables
variable "cloudsql_authorized_networks" {
  type        = map(string)
}
variable "cloudsql_allocated_ip_range" {
  type        = string
}
variable "cloudsql_deletion_protection_for_tf" {
  type        = bool
}
variable "cloudsql_deletion_protection_enabled_for_gcp" {
  type        = bool
}

variable "mysql_database_version" {
  type        = string
}
variable "mysql_name" {
  description = "mysql_name"
  type        = string
}
variable "mysql_transaction_log_retention_days" {
  type        = number
}
variable "mysql_disk_autoresize" {
  type        = bool
}
variable "mysql_disk_autoresize_limit" {
  type        = number
}
variable "mysql_disk_size" {
  type        = number
}
variable "mysql_disk_type" {
  type        = string
}
variable "mysql_backup_binary_log_enabled" {
  type        = bool
}
variable "mysql_backup_enabled" {
  type        = bool
}
variable "mysql_backup_start_time" {
  type        = string
}
variable "mysql_backup_retained_backups" {
  type        = number
}
variable "mysql_pricing_plan" {
  type        = string
}
variable "mysql_tier" {
  type        = string
}
variable "mysql_assigned_public_ip" {
  type        = string
}
variable "mysql_database_name" {
  type        = string
}


