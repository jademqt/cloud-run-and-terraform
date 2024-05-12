# Load-Balancer - Network Endpoint Groups 
resource "google_compute_region_network_endpoint_group" "neg_data_collector" {
  provider              = google-beta
  region                = var.region
  project               = var.project_id
  name                  = var.neg_data_collector_name
  network_endpoint_type = "SERVERLESS"
  cloud_run {
    service = var.output_cloud_run_02_name
  }
}

# Load-Balancer - Backend service
resource "google_compute_backend_service" "backend_service_data_collector" {
  project               = var.project_id
  name                  = var.backend_service_data_collector_name
  protocol              = "HTTP"
  load_balancing_scheme = "EXTERNAL_MANAGED"
  backend {
    group = google_compute_region_network_endpoint_group.neg_data_collector.id
  }
}

# Load-Balancer - URL map 
resource "google_compute_url_map" "url_map_data_collector" {
  project         = var.project_id
  name            = var.url_map_data_collector_name
  default_service = google_compute_backend_service.backend_service_data_collector.id
}

# Load-Balancer - Target HTTP proxy
resource "google_compute_target_http_proxy" "target_http_proxy_data_collector" {
  project = var.project_id
  name    = var.target_http_proxy_data_collector_name
  url_map = google_compute_url_map.url_map_data_collector.id
}

# Load-Balancer - Forwarding Rule
resource "google_compute_global_forwarding_rule" "global_forwarding_rule_data_collector" {
  project               = var.project_id
  name                  = var.global_forwarding_rule_data_collector_name
    ip_address            = var.output_google_compute_global_address_global_external_address_lb_address
  provider              = google-beta
  load_balancing_scheme = "EXTERNAL_MANAGED"
  port_range            = "80"
  target                = google_compute_target_http_proxy.target_http_proxy_data_collector.id
}
