# general variables
variable "project_id" {
  type        = string
}
variable "region" {
  type        = string
}
variable "region_backup" {
  type        = string
}
variable "project_number" {
  type        = string
}

# output variables
variable "output_service_account_cloud_run_02_email" {
  type        = string
}
variable "output_service_account_cloud_run_03_email" {
  type        = string
}
variable "output_service_account_cloud_run_04_email" {
  type        = string
}
variable "output_service_account_cloud_run_05_email" {
  type        = string
}
variable "output_service_account_cloud_run_invoker_email" {
  type        = string
}
variable "output_iam_policy_no_auth_for_cloud_run_policy_data" {
  type        = string
}
variable "output_vpc_id" {
  type        = string
}
variable "output_serverless_vpc_access_id" {
  type        = string
}
variable "output_google_compute_global_address_global_external_address_lb_address" {
  description = "output_google_compute_global_address_global_external_address_lb"
  type        = string
}

# secrets
variable "secret_mysql_user_password_key" {
  type        = string
}


# cloud run general variables
variable "cloud_run_min_instance_count" {
  type        = number
}
variable "cloud_run_max_instance_count" {
  type        = number
}
variable "region_type2" {
  type        = string
}

# cloud run 02 variables (service with sidecar)
variable "cloud_run_02_name" {
  type        = string
}
# cloud run 02 - ingress container - variables
variable "cloud_run_02_container_ingress_image_display_name" {
  type        = string
}
variable "cloud_run_02_container_ingress_path" {
  type        = string
}
variable "cloud_run_02_container_ingress_port" {
  type        = number
}
variable "cloud_run_02_container_ingress_cpu" {
  type        = number
}
variable "cloud_run_02_container_ingress_ram" {
  type        = string
}
variable "cloud_run_02_container_ingress_envs" {
  type        = map(string)
}
# cloud run 02 - proxy container - variables
variable "cloud_run_02_container_proxy_image_display_name" {
  type        = string
}
variable "cloud_run_02_container_proxy_path" {
  type        = string
}
variable "cloud_run_02_container_proxy_cpu" {
  type        = number
}
variable "cloud_run_02_container_proxy_ram" {
  type        = string
}
variable "cloud_run_02_container_proxy_envs" {
  type        = map(string)
}


# cloud run 03 variables (scheduled job)
variable "cloud_run_03_name" {
  type        = string
}
variable "cloud_run_03_container_timeout" {
  type        = string
}
variable "cloud_run_03_container_max_retries" {
  type        = string
}
variable "cloud_run_03_container_image_display_name" {
  type        = string
}
variable "cloud_run_03_container_path" {
  type        = string
}
variable "cloud_run_03_container_cpu" {
  type        = number
}
variable "cloud_run_03_container_ram" {
  type        = string
}
variable "cloud_run_03_container_env_name" {
  type        = string
}

# cloud run 04 variables (scheduled service)
variable "cloud_run_04_name" {
  type        = string
}
variable "cloud_run_04_container_image_display_name" {
  type        = string
}
variable "cloud_run_04_container_path" {
  type        = string
}
variable "cloud_run_04_container_port" {
  type        = number
}
variable "cloud_run_04_container_cpu" {
  type        = number
}
variable "cloud_run_04_container_ram" {
  type        = string
}
variable "cloud_run_04_container_envs" {
  type        = map(string)
}

# cloud run 05 variables (scheduled job)
variable "cloud_run_05_name" {
  type        = string
}
variable "cloud_run_05_container_image_display_name" {
  type        = string
}
variable "cloud_run_05_container_path" {
  type        = string
}
variable "cloud_run_05_container_timeout" {
  type        = string
}
variable "cloud_run_05_container_max_retries" {
  type        = string
}
variable "cloud_run_05_container_cpu" {
  type        = number
}
variable "cloud_run_05_container_ram" {
  type        = string
}
variable "cloud_run_05_container_envs" {
  type        = map(string)
}

# Cloud Scheduler variables
# Scheduler for cloud run 04 data analysis
variable "schedule_analyze_data_co2_name" {
  type        = string
}
variable "schedule_analyze_data_co2_description" {
  type        = string
}
variable "schedule_analyze_data_pm25_name" {
  type        = string
}
variable "schedule_analyze_data_pm25_description" {
  type        = string
}
variable "schedule_analyze_data_ozone_name" {
  type        = string
}
variable "schedule_analyze_data_ozone_description" {
  type        = string
}
variable "schedule_analyze_data_schedule" {
  type        = string
}
variable "schedule_analyze_data_time_zone" {
  type        = string
}
variable "schedule_analyze_data_attempt_deadline" {
  type        = string
}
variable "schedule_analyze_data_retry_count" {
  type        = string
}
variable "schedule_analyze_data_co2_route" {
  type        = string
}
variable "schedule_analyze_data_pm25_route" {
  type        = string
}
variable "schedule_analyze_data_ozone_route" {
  type        = string
}

# Scheduler for cloud run 05 clean data 
variable "schedule_clean_data_name" {
  type        = string
}
variable "schedule_clean_data_description" {
  type        = string
}
variable "schedule_clean_data_schedule" {
  type        = string
}
variable "schedule_clean_data_attempt_deadline" {
  type        = string
}
variable "schedule_clean_data_retry_count" {
  type        = string
}

# Scheduler for cloud run 03 create
variable "schedule_create_data_name" {
  type        = string
}
variable "schedule_create_data_description" {
  type        = string
}
variable "schedule_create_data_schedule" {
  type        = string
}
variable "schedule_create_data_attempt_deadline" {
  type        = string
}
variable "schedule_create_data_retry_count" {
  type        = string
}
