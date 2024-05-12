# Cloud SQL - MySQL
resource "google_sql_database_instance" "mysql" {
  database_version    = var.mysql_database_version
  name                = var.mysql_name
  project             = var.project_id
  region              = var.region
  deletion_protection = var.cloudsql_deletion_protection_for_tf

  settings {
    activation_policy           = "ALWAYS"
    availability_type           = "ZONAL"
    deletion_protection_enabled = var.cloudsql_deletion_protection_enabled_for_gcp

    backup_configuration {
      backup_retention_settings {
        retained_backups = var.mysql_backup_retained_backups
        retention_unit   = "COUNT"
      }

      binary_log_enabled             = var.mysql_backup_binary_log_enabled
      enabled                        = var.mysql_backup_enabled
      location                       = var.global_region
      start_time                     = var.mysql_backup_start_time
      transaction_log_retention_days = var.mysql_transaction_log_retention_days
    }

    disk_autoresize       = var.mysql_disk_autoresize
    disk_autoresize_limit = var.mysql_disk_autoresize_limit
    disk_size             = var.mysql_disk_size
    disk_type             = var.mysql_disk_type


    ip_configuration {
      #allocated_ip_range                            = var.cloudsql_allocated_ip_range
      enable_private_path_for_google_cloud_services = true

      dynamic "authorized_networks" {
        for_each = var.cloudsql_authorized_networks

        content {
          name  = authorized_networks.key
          value = authorized_networks.value
        }
      }

      ipv4_enabled    = var.mysql_assigned_public_ip
      private_network = var.output_vpc_id
    }

    location_preference {
      zone = var.region_location
    }

    pricing_plan = var.mysql_pricing_plan
    tier         = var.mysql_tier
  }
  # lifecycle {
  #   prevent_destroy = true
  # }
}