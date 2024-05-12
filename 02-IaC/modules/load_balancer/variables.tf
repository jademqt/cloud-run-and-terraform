# general variables
variable "project_id" {
  type        = string
}

variable "region" {
  type        = string
}

# output variables
variable "output_cloud_run_02_name" {
  type = string
}

variable "output_google_compute_global_address_global_external_address_lb_address" {
  description = "output_google_compute_global_address_global_external_address_lb"
  type        = string
}

# laod balancer variables
variable "neg_data_collector_name" {
  type        = string
}
variable "backend_service_data_collector_name" {
  type        = string
}

variable "url_map_data_collector_name" {
  type        = string
}

variable "target_http_proxy_data_collector_name" {
  type        = string
}

variable "global_forwarding_rule_data_collector_name" {
  type        = string
}

