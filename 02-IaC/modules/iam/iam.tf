# Service account 
resource "google_service_account" "service_account_cloud_run_02" {
  project      = var.project_id
  account_id   = var.service_account_cloudrun_02_id
  display_name = var.service_account_cloudrun_02_id
  description  = var.service_account_cloudrun_02_description
}
resource "google_service_account" "service_account_cloud_run_03" {
  project      = var.project_id
  account_id   = var.service_account_cloudrun_03_id
  display_name = var.service_account_cloudrun_03_id
  description  = var.service_account_cloudrun_03_description
}
resource "google_service_account" "service_account_cloud_run_04" {
  project      = var.project_id
  account_id   = var.service_account_cloudrun_04_id
  display_name = var.service_account_cloudrun_04_id
  description  = var.service_account_cloudrun_04_description
}
resource "google_service_account" "service_account_cloud_run_05" {
  project      = var.project_id
  account_id   = var.service_account_cloudrun_05_id
  display_name = var.service_account_cloudrun_05_id
  description  = var.service_account_cloudrun_05_description
}
resource "google_service_account" "service_account_cloud_run_invoker" {
  project      = var.project_id
  account_id   = var.service_account_cloud_run_invoker_id
  display_name = var.service_account_cloud_run_invoker_id
  description  = var.service_account_cloud_run_invoker_description
}


# IAM binding
resource "google_project_iam_binding" "iam_project_secret_accessor" {
  project = var.project_id
  role    = "roles/secretmanager.secretAccessor"
  members = [
    "serviceAccount:${google_service_account.service_account_cloud_run_02.email}",
    "serviceAccount:${google_service_account.service_account_cloud_run_03.email}",
    "serviceAccount:${google_service_account.service_account_cloud_run_04.email}",
    "serviceAccount:${google_service_account.service_account_cloud_run_05.email}",
  ]
}
resource "google_project_iam_binding" "iam_project_cloud_sql_editor" {
  project = var.project_id
  role    = "roles/cloudsql.editor"
  members = [
    "serviceAccount:${google_service_account.service_account_cloud_run_02.email}",
    "serviceAccount:${google_service_account.service_account_cloud_run_03.email}",
    "serviceAccount:${google_service_account.service_account_cloud_run_04.email}",
    "serviceAccount:${google_service_account.service_account_cloud_run_05.email}",
  ]
}
resource "google_project_iam_binding" "iam_project_cloud_run_invoker" {
  project = var.project_id
  role    = "roles/run.invoker"
  members = [
    "serviceAccount:${google_service_account.service_account_cloud_run_invoker.email}",
  ]
}

# IAM policy
data "google_iam_policy" "iam_policy_no_auth_for_cloud_run" {
  binding {
    role = "roles/run.invoker"
    members = [
      "allUsers",
    ]
  }
}