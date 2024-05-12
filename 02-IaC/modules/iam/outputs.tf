output "output_iam_policy_no_auth_for_cloud_run_policy_data" {
  value       = data.google_iam_policy.iam_policy_no_auth_for_cloud_run.policy_data
}

output "output_service_account_cloud_run_02_email" {
  value       = google_service_account.service_account_cloud_run_02.email
}

output "output_service_account_cloud_run_03_email" {
  value       = google_service_account.service_account_cloud_run_03.email
}

output "output_service_account_cloud_run_04_email" {
  value       = google_service_account.service_account_cloud_run_04.email
}

output "output_service_account_cloud_run_05_email" {
  value       = google_service_account.service_account_cloud_run_05.email
}
output "output_service_account_cloud_run_invoker_email" {
  value       = google_service_account.service_account_cloud_run_invoker.email
}