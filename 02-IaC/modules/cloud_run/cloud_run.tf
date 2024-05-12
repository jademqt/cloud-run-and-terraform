# Secrets
resource "google_secret_manager_secret" "mysql_user_password" {
  project   = var.project_id
  secret_id = var.secret_mysql_user_password_key
  replication {
    auto {}
  }
}

data "google_secret_manager_secret_version" "mysql_user_password" {
  secret = google_secret_manager_secret.mysql_user_password.id
}

# Cloud run service IAM policy
resource "google_cloud_run_service_iam_policy" "cloud_run_02_iam_policy_no_auth" {
  project     = var.project_id
  location    = var.region
  service     = google_cloud_run_v2_service.cloud_run_02.name
  policy_data = var.output_iam_policy_no_auth_for_cloud_run_policy_data
}
resource "google_cloud_run_service_iam_policy" "cloud_run_04_iam_policy_no_auth" {
  project     = var.project_id
  location    = var.region
  service     = google_cloud_run_v2_service.cloud_run_04.name
  policy_data = var.output_iam_policy_no_auth_for_cloud_run_policy_data
}

# Cloud run - services
resource "google_cloud_run_v2_service" "cloud_run_02" {
  name     = var.cloud_run_02_name
  project  = var.project_id
  location = var.region
  ingress  = "INGRESS_TRAFFIC_INTERNAL_LOAD_BALANCER"

  template {
    scaling {
      min_instance_count = var.cloud_run_min_instance_count
      max_instance_count = var.cloud_run_max_instance_count
    }
    service_account = var.output_service_account_cloud_run_02_email
    vpc_access {
      egress    = "ALL_TRAFFIC"
      connector = var.output_serverless_vpc_access_id
    }

    # Ingress container
    containers {
      name  = var.cloud_run_02_container_ingress_image_display_name
      image = var.cloud_run_02_container_ingress_path

      ports {
        container_port = var.cloud_run_02_container_ingress_port
      }

      resources {
        limits = {
          cpu    = var.cloud_run_02_container_ingress_cpu
          memory = var.cloud_run_02_container_ingress_ram
        }
        cpu_idle = false
      }
      dynamic "env" {
        for_each = var.cloud_run_02_container_ingress_envs
        content {
          name  = env.key
          value = env.value
        }
      }

      env {
        name = var.secret_mysql_user_password_key
        value_source {
          secret_key_ref {
            secret  = google_secret_manager_secret.mysql_user_password.secret_id
            version = "latest"
          }
        }
      }
    }
    # proxy container
    containers {
      name  = var.cloud_run_02_container_proxy_image_display_name
      image = var.cloud_run_02_container_proxy_path
      
      resources {
        limits = {
          cpu    = var.cloud_run_02_container_proxy_cpu
          memory = var.cloud_run_02_container_proxy_ram
        }
        cpu_idle = false
      }
      dynamic "env" {
        for_each = var.cloud_run_02_container_proxy_envs
        content {
          name  = env.key
          value = env.value
        }
      }
    }
  }
}

resource "google_cloud_run_v2_service" "cloud_run_04" {
  name     = var.cloud_run_04_name
  project  = var.project_id
  location = var.region
  ingress  = "INGRESS_TRAFFIC_INTERNAL_ONLY"

  template {
    scaling {
      min_instance_count = var.cloud_run_min_instance_count
      max_instance_count = var.cloud_run_max_instance_count
    }
    service_account = var.output_service_account_cloud_run_04_email
    vpc_access {
      egress    = "ALL_TRAFFIC"
      connector = var.output_serverless_vpc_access_id
    }

    containers {
      name  = var.cloud_run_04_container_image_display_name
      image = var.cloud_run_04_container_path

      ports {
        container_port = var.cloud_run_04_container_port
      }

      resources {
        limits = {
          cpu    = var.cloud_run_04_container_cpu
          memory = var.cloud_run_04_container_ram
        }
        cpu_idle = false
      }
      dynamic "env" {
        for_each = var.cloud_run_04_container_envs
        content {
          name  = env.key
          value = env.value
        }
      }
      env {
        name = var.secret_mysql_user_password_key
        value_source {
          secret_key_ref {
            secret  = google_secret_manager_secret.mysql_user_password.secret_id
            version = "latest"
          }
        }
      }
    }
  }
}

# Cloud run - job
resource "google_cloud_run_v2_job" "cloud_run_03" {
  name     = var.cloud_run_03_name
  location = var.region

  template {
    template {
      timeout = var.cloud_run_03_container_timeout
      service_account = var.output_service_account_cloud_run_03_email
      vpc_access {
        egress    = "ALL_TRAFFIC"
        connector = var.output_serverless_vpc_access_id
      }
      max_retries = var.cloud_run_03_container_max_retries
      containers {
        name  = var.cloud_run_03_container_image_display_name
        image = var.cloud_run_03_container_path

        resources {
          limits = {
            cpu    = var.cloud_run_03_container_cpu
            memory = var.cloud_run_03_container_ram
          }
        }
        env {
          name  = var.cloud_run_03_container_env_name
          value = "${google_cloud_run_v2_service.cloud_run_02.uri}"
        }
      }       
    }
  }
}

resource "google_cloud_run_v2_job" "cloud_run_05" {
  name     = var.cloud_run_05_name
  location = var.region

  template {
    template {
      timeout = var.cloud_run_05_container_timeout
      service_account = var.output_service_account_cloud_run_05_email
      vpc_access {
        egress    = "ALL_TRAFFIC"
        connector = var.output_serverless_vpc_access_id
      }
      max_retries = var.cloud_run_05_container_max_retries
      containers {
        name  = var.cloud_run_05_container_image_display_name
        image = var.cloud_run_05_container_path

        resources {
          limits = {
            cpu    = var.cloud_run_05_container_cpu
            memory = var.cloud_run_05_container_ram
          }
        }
        dynamic "env" {
          for_each = var.cloud_run_05_container_envs
          content {
            name  = env.key
            value = env.value
          }
        }
        env {
          name = var.secret_mysql_user_password_key
          value_source {
            secret_key_ref {
              secret  = google_secret_manager_secret.mysql_user_password.secret_id
              version = "latest"
            }
          }
        }
      }       
    }
  }
}

# Cloud Scheduler
resource "google_cloud_scheduler_job" "schedule_analyze_data_co2" {
  region           = var.region_backup
  name             = var.schedule_analyze_data_co2_name
  description      = var.schedule_analyze_data_co2_description
  schedule         = var.schedule_analyze_data_schedule
  time_zone        = var.schedule_analyze_data_time_zone
  attempt_deadline = var.schedule_analyze_data_attempt_deadline

  retry_config {
    retry_count = var.schedule_analyze_data_retry_count
  }

  http_target {
    http_method = "GET"
    uri         = "${google_cloud_run_v2_service.cloud_run_04.uri}${var.schedule_analyze_data_co2_route}"
    headers = {
      "Content-Type" = "application/json"
    }
  }
}
resource "google_cloud_scheduler_job" "schedule_analyze_data_pm25" {
  region           = var.region_backup
  name             = var.schedule_analyze_data_pm25_name
  description      = var.schedule_analyze_data_pm25_description
  schedule         = var.schedule_analyze_data_schedule
  time_zone        = var.schedule_analyze_data_time_zone
  attempt_deadline = var.schedule_analyze_data_attempt_deadline

  retry_config {
    retry_count = var.schedule_analyze_data_retry_count
  }

  http_target {
    http_method = "GET"
    uri         = "${google_cloud_run_v2_service.cloud_run_04.uri}${var.schedule_analyze_data_pm25_route}"
    headers = {
      "Content-Type" = "application/json"
    }
  }
}
resource "google_cloud_scheduler_job" "schedule_analyze_data_ozone" {
  region           = var.region_backup
  name             = var.schedule_analyze_data_ozone_name
  description      = var.schedule_analyze_data_ozone_description
  schedule         = var.schedule_analyze_data_schedule
  time_zone        = var.schedule_analyze_data_time_zone
  attempt_deadline = var.schedule_analyze_data_attempt_deadline

  retry_config {
    retry_count = var.schedule_analyze_data_retry_count
  }

  http_target {
    http_method = "GET"
    uri         = "${google_cloud_run_v2_service.cloud_run_04.uri}${var.schedule_analyze_data_ozone_route}"
    headers = {
      "Content-Type" = "application/json"
    }
  }
}

resource "google_cloud_scheduler_job" "schedule_clean_data" {
  name             = var.schedule_clean_data_name
  description      = var.schedule_clean_data_description
  schedule         = var.schedule_clean_data_schedule
  attempt_deadline = var.schedule_clean_data_attempt_deadline
  region           = var.region_backup
  project          = var.project_id

  retry_config {
    retry_count = var.schedule_clean_data_retry_count
  }

  http_target {
    http_method = "POST"
    uri         = "https://${var.region}-run.googleapis.com/apis/run.googleapis.com/v1/namespaces/${var.project_number}/jobs/${var.cloud_run_05_name}:run"

    oauth_token {
      service_account_email = var.output_service_account_cloud_run_invoker_email
    }
  }
}

resource "google_cloud_scheduler_job" "schedule_create_data" {
  name             = var.schedule_create_data_name
  description      = var.schedule_create_data_description
  schedule         = var.schedule_create_data_schedule
  attempt_deadline = var.schedule_create_data_attempt_deadline
  region           = var.region_backup
  project          = var.project_id

  retry_config {
    retry_count = var.schedule_create_data_retry_count
  }

  http_target {
    http_method = "POST"
    uri         = "https://${var.region}-run.googleapis.com/apis/run.googleapis.com/v1/namespaces/${var.project_number}/jobs/${var.cloud_run_03_name}:run"

    oauth_token {
      service_account_email = var.output_service_account_cloud_run_invoker_email
    }
  }
}