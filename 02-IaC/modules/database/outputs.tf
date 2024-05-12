output "output_google_mysql_instance_ip" {
  value       = google_sql_database_instance.mysql.private_ip_address
}

