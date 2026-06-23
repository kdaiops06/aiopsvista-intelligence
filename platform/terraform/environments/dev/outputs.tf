output "project_id" {
  description = "Dev project ID."
  value       = module.project.project_id
}

output "shared_vpc_name" {
  description = "Shared VPC name."
  value       = module.shared_vpc.network_name
}

output "gke_cluster_name" {
  description = "GKE cluster name."
  value       = module.gke.cluster_name
}

output "workload_identity_pool" {
  description = "Workload Identity pool configured for the cluster."
  value       = module.gke.workload_identity_pool
}

output "budget_name" {
  description = "Configured monthly FinOps budget resource name."
  value       = module.budget.budget_name
}

output "budget_notification_channel" {
  description = "Notification channel used by budget alerts."
  value       = module.budget.notification_channel_name
}

output "budget_thresholds" {
  description = "Configured current spend alert thresholds for the budget."
  value       = module.budget.configured_thresholds
}

output "ai_finops_dataset_id" {
  description = "BigQuery dataset ID for AI FinOps usage data."
  value       = module.bigquery_ai_finops.dataset_id
}

output "ai_finops_table_id" {
  description = "BigQuery table ID for AI usage records."
  value       = module.bigquery_ai_finops.table_id
}

output "ai_usage_collector_service_name" {
  description = "Cloud Run service name for the AI Usage Collector."
  value       = module.ai_usage_collector.service_name
}

output "ai_usage_collector_service_url" {
  description = "Cloud Run service URL for the AI Usage Collector."
  value       = module.ai_usage_collector.service_url
}

output "ai_usage_collector_service_account_email" {
  description = "Runtime service account email for the AI Usage Collector."
  value       = module.ai_usage_collector.service_account_email
}

output "ai_usage_collector_artifact_registry_repository_url" {
  description = "Artifact Registry URL for the AI Usage Collector image repository."
  value       = module.ai_usage_collector.artifact_registry_repository_url
}
