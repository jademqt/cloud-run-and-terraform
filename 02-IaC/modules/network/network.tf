
# VPC
resource "google_compute_network" "vpc" {
  auto_create_subnetworks                   = var.vpc_auto_create_subnetworks
  mtu                                       = var.vpc_mtu
  name                                      = var.vpc_name
  project                                   = var.project_id
  routing_mode                              = "GLOBAL"
  enable_ula_internal_ipv6                  = true
  network_firewall_policy_enforcement_order = "AFTER_CLASSIC_FIREWALL"
  description                               = var.vpc_description
  internal_ipv6_range                       = var.vpc_internal_ipv6_range
  # lifecycle {
  #   prevent_destroy = true
  # }
}

# Firewall
resource "google_compute_firewall" "allow-internal" {
  name    = "allow-internal"
  network = google_compute_network.vpc.id
  project = var.project_id

  priority  = 1000
  direction = "INGRESS"

  source_ranges = [
    "10.0.0.0/8",
    "172.16.0.0/12",
    "192.168.0.0/16"
  ]

  allow {
    protocol = "all"
  }
}

# Reserved IP 
resource "google_compute_global_address" "global_internal_address_vpc" {
  address       = var.global_internal_address_vpc_address
  address_type  = var.global_internal_address_vpc_address_type
  name          = var.global_internal_address_vpc_name
  network       = "https://www.googleapis.com/compute/v1/projects/${var.project_id}/global/networks/${var.vpc_name}"
  prefix_length = var.global_internal_address_vpc_prefix_lenght
  project       = var.project_id
  purpose       = var.global_internal_address_vpc_purpose
}

resource "google_compute_global_address" "global_external_address_lb" {
  address_type = var.global_external_address_lb_address_type
  description  = var.global_external_address_lb_description
  ip_version   = var.global_external_address_lb_ip_version
  name         = var.global_external_address_lb_name
  project      = var.project_id
}


# Service private access
resource "google_service_networking_connection" "service-private-access" {
  network                 = "/projects/${var.project_id}/global/networks/${var.vpc_name}"
  service                 = "servicenetworking.googleapis.com"
  reserved_peering_ranges = [google_compute_global_address.global_internal_address_vpc.name]
}

# Serverless VPC access
resource "google_vpc_access_connector" "serverless_vpc_access" {
  name   = var.serverless_vpc_access_name
  region = var.region
  network = google_compute_network.vpc.id
  project = var.project_id
  ip_cidr_range = var.serverless_vpc_access_ip_cidr_range
  min_instances  = var.serverless_vpc_access_min_instance
  max_instances  = var.serverless_vpc_access_max_instance
  max_throughput = var.serverless_vpc_access_max_throughput
  machine_type   = var.serverless_vpc_access_machine_type
}

