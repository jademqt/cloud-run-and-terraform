output "output_vpc_id" {
  value       = google_compute_network.vpc.id
}

output "output_serverless_vpc_access_id" {
  value       = google_vpc_access_connector.serverless_vpc_access.id
}

output "output_service_private_access" {
  value = google_service_networking_connection.service-private-access
}

output "output_google_compute_global_address_global_external_address_lb_address" {
  value = google_compute_global_address.global_external_address_lb.address
}