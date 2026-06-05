output "project_id" {
  description = "Created project ID."
  value       = google_project.this.project_id
}

output "project_number" {
  description = "Created project number."
  value       = google_project.this.number
}

output "enabled_apis" {
  description = "APIs enabled in the project."
  value       = [for svc in google_project_service.enabled : svc.service]
}

output "gke_node_service_account_email" {
  description = "Email of the service account used by GKE nodes."
  value       = google_service_account.gke_nodes.email
}
