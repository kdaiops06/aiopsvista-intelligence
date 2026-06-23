output "service_account_email" {
  description = "Email address of the Cloud Run runtime service account."
  value       = google_service_account.ai_usage_collector.email
}

output "artifact_registry_repository_name" {
  description = "Fully qualified Artifact Registry repository name."
  value       = google_artifact_registry_repository.ai_usage_collector.name
}

output "artifact_registry_repository_url" {
  description = "Docker image base URL for the collector repository."
  value       = local.repository_url
}

output "service_name" {
  description = "Cloud Run service name."
  value       = var.service_name
}

output "service_url" {
  description = "Cloud Run service URL, when deployed."
  value       = try(google_cloud_run_v2_service.ai_usage_collector[0].uri, null)
}
