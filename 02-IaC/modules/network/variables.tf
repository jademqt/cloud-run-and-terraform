# general variables
variable "project_id" {
  type        = string
}
variable "region" {
  type        = string
}

# vpc variables
variable "vpc_name" {
  type        = string
}
variable "vpc_auto_create_subnetworks" {
  type        = bool
}
variable "vpc_mtu" {
  type        = number
}
variable "vpc_description" {
  type        = string
}
variable "vpc_internal_ipv6_range" {
  type        = string
}

# Reserved IP variables : Google managed services VPC
variable "global_internal_address_vpc_name" {
  type        = string
}
variable "global_internal_address_vpc_address" {
  type        = string
}
variable "global_internal_address_vpc_address_type" {
  type        = string
}
variable "global_internal_address_vpc_prefix_lenght" {
  type        = number
}
variable "global_internal_address_vpc_purpose" {
  type        = string
}

# Reserved IP variables : Static public IP for the LB 
variable "global_external_address_lb_address_type" {
  type        = string
}
variable "global_external_address_lb_description" {
  type        = string
}
variable "global_external_address_lb_ip_version" {
  type        = string
}
variable "global_external_address_lb_name" {
  type        = string
}

# Serverless VPC access variables
variable "serverless_vpc_access_name" {
  type        = string
}
variable "serverless_vpc_access_min_instance" {
  type        = string
}
variable "serverless_vpc_access_max_instance" {
  type        = string
}
variable "serverless_vpc_access_machine_type" {
  type        = string
}
variable "serverless_vpc_access_max_throughput" {
  type        = number
}
variable "serverless_vpc_access_ip_cidr_range" {
  type        = string
}


