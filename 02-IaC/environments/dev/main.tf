terraform {
  backend "gcs" {
    bucket = "air-quality-monitoring-terraform-state"
    prefix = "state"
  }
}

module "iam" {
  source = "../../modules/iam"

  # general variables
  project_id = "terraform-test-420413"

  # Service account variables
  service_account_cloudrun_02_id          = "cr-compte-de-service-02"
  service_account_cloudrun_02_description = "compte de service pour le cloud run 02-data-collector : service"
  service_account_cloudrun_03_id   ="cr-compte-de-service-03"
  service_account_cloudrun_03_description ="compte de service pour le cloud run 03-data-cleanup : job"
  service_account_cloudrun_04_id ="cr-compte-de-service-04"
  service_account_cloudrun_04_description ="compte de service pour le cloud run 04-data-analysis : service schedulé"
  service_account_cloudrun_05_id ="cr-compte-de-service-05"
  service_account_cloudrun_05_description ="compte de service pour le cloud run 05-data-cleanup : job"
  service_account_cloud_run_invoker_id ="scheduler-compte-de-service"
  service_account_cloud_run_invoker_description ="compte de service pour que le service cloud scheduler puisse invoquer les cloud run."
}

module "network" {
  source = "../../modules/network"

  # general variables
  project_id = "terraform-test-420413"
  region     = "europe-west9"

  # vpc variables
  vpc_name                    = "vpc-air-quality"
  vpc_auto_create_subnetworks = false
  vpc_mtu                     = 1460
  vpc_description             = "Network so that the various services communicate via their private address."
  vpc_internal_ipv6_range     = "fd20:7da:2d4f:0:0:0:0:0/48" #test
  #vpc_internal_ipv6_range     = "fd20:22a:3632:0:0:0:0:0/48"

  # Reserved IP variables : Google managed services VPC
  global_internal_address_vpc_name          = "google-managed-services-vpc"
  global_internal_address_vpc_address       = "172.30.0.0"
  global_internal_address_vpc_address_type  = "INTERNAL"
  global_internal_address_vpc_prefix_lenght = 16
  global_internal_address_vpc_purpose       = "VPC_PEERING"

   # Reserved IP variables : Static public IP for the LB 
  global_external_address_lb_address_type = "EXTERNAL"
  global_external_address_lb_description  = "Static public IP assigned to Load Balancer connected to Cloud Run service data-collector"
  global_external_address_lb_ip_version   = "IPV4"
  global_external_address_lb_name         = "public-lb-ip"

  # Serverless VPC access variables
  serverless_vpc_access_name           = "connector"
  serverless_vpc_access_min_instance   = "2"
  serverless_vpc_access_max_instance   = "10"
  serverless_vpc_access_machine_type   = "e2-micro"
  serverless_vpc_access_max_throughput = 1000
  serverless_vpc_access_ip_cidr_range = "10.8.0.0/28"
}

module "database" {
  source = "../../modules/database"

  # general variables
  project_id      = "terraform-test-420413"
  region          = "europe-west9"
  region_location = "europe-west9-c"
  global_region   = "eu"
  vpc_name        = "vpc-appse-poc"

  # outputs variables
  output_vpc_id                 = module.network.output_vpc_id
  output_service_private_access = module.network.output_service_private_access

  # Cloud SQL general variables
  cloudsql_allocated_ip_range                  = "google-managed-services-vpc-appse-staging"
  cloudsql_deletion_protection_for_tf          = false
  cloudsql_deletion_protection_enabled_for_gcp = false
  cloudsql_authorized_networks = {
    JadeM-Bayonne : "89.84.216.134/32"
    JadeM-Reims : "79.85.27.96/32"
  }
  # Cloud SQL MySQL variables
  mysql_name                           = "mysql-air-quality"
  mysql_transaction_log_retention_days = 7
  mysql_disk_autoresize                = true
  mysql_disk_autoresize_limit          = 0
  mysql_disk_size                      = 10
  mysql_disk_type                      = "PD_SSD"
  mysql_backup_binary_log_enabled      = true
  mysql_backup_enabled                 = true
  mysql_backup_start_time              = "17:00"
  mysql_backup_retained_backups        = 7
  mysql_pricing_plan                   = "PER_USE"
  mysql_tier                           = "db-g1-small"
  mysql_assigned_public_ip             = true
  mysql_database_version               = "MYSQL_8_0"
  mysql_database_name                  = "measurements"
}

module "cloud_run" {
  source = "../../modules/cloud_run"

  # genaral variables
  project_id = "terraform-test-420413"
  region     = "europe-west9"
  region_backup = "europe-west1"
  region_type2 = "eu-west9"
  project_number ="68976813959"

  # outputs variables
  output_service_account_cloud_run_02_email                       = module.iam.output_service_account_cloud_run_02_email
  output_service_account_cloud_run_03_email                       = module.iam.output_service_account_cloud_run_03_email
  output_service_account_cloud_run_04_email                       = module.iam.output_service_account_cloud_run_04_email
  output_service_account_cloud_run_05_email                       = module.iam.output_service_account_cloud_run_05_email
  output_service_account_cloud_run_invoker_email                       = module.iam.output_service_account_cloud_run_invoker_email
  output_iam_policy_no_auth_for_cloud_run_policy_data = module.iam.output_iam_policy_no_auth_for_cloud_run_policy_data
  output_vpc_id = module.network.output_vpc_id
  output_serverless_vpc_access_id = module.network.output_serverless_vpc_access_id
  output_google_compute_global_address_global_external_address_lb_address = module.network.output_google_compute_global_address_global_external_address_lb_address
  
  # output_google_secret_manager_secret_mysql_user_password_id = module.database.output_google_secret_manager_secret_mysql_user_password_id

  # secrets
  secret_mysql_user_password_key = "DB_PASS"


  # cloud run general variables
  cloud_run_min_instance_count = 0
  cloud_run_max_instance_count = 1

  # cloud run 02 (data collector)
  cloud_run_02_name               = "cr-02-data-collector"
  cloud_run_02_container_ingress_image_display_name = "cr-02-data-collector-container"
  cloud_run_02_container_ingress_path = "europe-west9-docker.pkg.dev/terraform-test-420413/air-quality-monitoring-apps/02-image-data-collector@sha256:c3ba385afc0aef4bc13f8e797c959d422a693e45a698433761cc09a61ad50777"
  cloud_run_02_container_ingress_port = "8080"
  cloud_run_02_container_ingress_cpu = 1
  cloud_run_02_container_ingress_ram = "512Mi"
  cloud_run_02_container_ingress_envs = {
    INSTANCE_HOST : "${module.database.output_google_mysql_instance_ip}"
    DB_NAME : "measurements"
    DB_PORT : "3306"
    DB_USER : "cloudrun-user"
  }
  cloud_run_02_container_proxy_image_display_name = "cr-02-proxy-container"
  cloud_run_02_container_proxy_path = "gcr.io/cloud-sql-connectors/cloud-sql-proxy:latest"
  cloud_run_02_container_proxy_cpu = 1
  cloud_run_02_container_proxy_ram = "512Mi"
  cloud_run_02_container_proxy_envs = {
    PORT : "3306"
  }

  # cloud run 03 (create data)
  cloud_run_03_name = "cr-03-create-data"
  cloud_run_03_container_timeout = "4.0s"
  cloud_run_03_container_max_retries = "2"
  cloud_run_03_container_image_display_name = "cr-03-create-data-container"
  cloud_run_03_container_path = "europe-west9-docker.pkg.dev/terraform-test-420413/air-quality-monitoring-apps/03-image-create-data@sha256:16e5925b2cfc0a439b7092d5e5a6c263969cf0f7731eb1b2bff1fa1d04c9c120"
  cloud_run_03_container_cpu = 1
  cloud_run_03_container_ram = "512Mi"
  cloud_run_03_container_env_name = "CR_URL"

  # cloud run (data analysis)
  cloud_run_04_name = "cr-04-data-analysis"
  cloud_run_04_container_image_display_name = "cr-04-data-analysis-container"
  cloud_run_04_container_path = "europe-west9-docker.pkg.dev/terraform-test-420413/air-quality-monitoring-apps/04-image-data-analysis@sha256:afd762249adf61d4b8bb8553f597d51e2cf94e474754038a6776b1245fc22c78"
  cloud_run_04_container_port = "8090"
  cloud_run_04_container_cpu = 1
  cloud_run_04_container_ram = "512Mi"
  cloud_run_04_container_envs = {
    INSTANCE_HOST : "${module.database.output_google_mysql_instance_ip}"
    DB_NAME : "measurements"
    DB_PORT : "3306"
    DB_USER : "cloudrun-user"
  }

  # cloud run (data cleanup)
  cloud_run_05_name = "cr-05-data-cleanup"
  cloud_run_05_container_image_display_name = "cr-05-data-cleanup-container"
  cloud_run_05_container_path = "europe-west9-docker.pkg.dev/terraform-test-420413/air-quality-monitoring-apps/05-data-cleanup@sha256:6ac3df5da1a4fe7486d1ef45cc0a9e7cf540038fe667e9bc8b52a897ed90159b"
  cloud_run_05_container_timeout = "4.0s"
  cloud_run_05_container_max_retries = "2"
  cloud_run_05_container_cpu = "1"
  cloud_run_05_container_ram = "512Mi"
  cloud_run_05_container_envs = {
    INSTANCE_HOST : "${module.database.output_google_mysql_instance_ip}"
    DB_NAME : "measurements"
    DB_PORT : "3306"
    DB_USER : "cloudrun-user"
    CO2_MAX : "430"
    PEM25_MAX : "18"
    OZONE_MAX : "105"
    CO2_MIN : "306"
    PEM25_MIN : "8"
    OZONE_MIN : "80"
  }

  # Scheduler for cloud run 04 data analysis - commun
  schedule_analyze_data_co2_name = "analyze-data-co2"
  schedule_analyze_data_co2_description = "Calculates average CO2 levels at each sensor location (in this case, city center, urban park and industrial zone)."
  schedule_analyze_data_pm25_name = "analyze-data-pm25"
  schedule_analyze_data_pm25_description = "Calculates average pm25 levels at each sensor location (in this case, city center, urban park and industrial zone)."
  schedule_analyze_data_ozone_name = "analyze-data-ozone"
  schedule_analyze_data_ozone_description = "Calculates average ozone levels at each sensor location (in this case, city center, urban park and industrial zone)."
  schedule_analyze_data_schedule = "0 0,12 * * *"
  schedule_analyze_data_time_zone = "Europe/Paris"
  schedule_analyze_data_attempt_deadline = "320s"
  schedule_analyze_data_retry_count = "1"
  schedule_analyze_data_co2_route = "/average/co2"
  schedule_analyze_data_pm25_route = "/average/pm25"
  schedule_analyze_data_ozone_route = "/average/ozone"

  # Scheduler for cloud run 05 clean data
  schedule_clean_data_name = "data-cleanup"
  schedule_clean_data_description = "Deletes entries in the database that are due to sensor errors (outliers) "
  schedule_clean_data_schedule = "0 6,12,18,0 * * *"
  schedule_clean_data_attempt_deadline = "320s"
  schedule_clean_data_retry_count = "1"

  # Scheduler for cloud run 03 create data
  schedule_create_data_name = "data-sending-sensors"
  schedule_create_data_description = "Imitates sensors that send data at regular times around a city"
  schedule_create_data_schedule = "*/15 * * * *"
  schedule_create_data_attempt_deadline = "320s"
  schedule_create_data_retry_count = "1"
}

module "load_balancer" {
  source = "../../modules/load_balancer"

  output_cloud_run_02_name = module.cloud_run.output_cloud_run_02_name
  output_google_compute_global_address_global_external_address_lb_address = module.network.output_google_compute_global_address_global_external_address_lb_address

  project_id                                                        = "terraform-test-420413"
  region                                                            = "europe-west9"
  neg_data_collector_name                                               = "neg-data-collector"
  backend_service_data_collector_name                                   = "backend-service-data-collector"
  url_map_data_collector_name                                           = "url-map-data-collector"
  target_http_proxy_data_collector_name                                 = "target-http-proxy-data-collector"
  global_forwarding_rule_data_collector_name                            = "global-forwarding-rule-data-collector"
}
