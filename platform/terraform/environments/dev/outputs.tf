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