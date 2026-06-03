output "network_name" {
  description = "Shared VPC name."
  value       = google_compute_network.this.name
}

output "network_self_link" {
  description = "Shared VPC self link."
  value       = google_compute_network.this.self_link
}

output "subnet_names" {
  description = "Created subnet names."
  value       = keys(google_compute_subnetwork.subnets)
}

output "subnet_self_links" {
  description = "Created subnet self links."
  value       = { for k, s in google_compute_subnetwork.subnets : k => s.self_link }
}
