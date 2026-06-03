resource "google_container_cluster" "this" {
  name     = var.cluster_name
  project  = var.project_id
  location = var.region

  network    = var.network_self_link
  subnetwork = var.subnetwork_self_link

  remove_default_node_pool = true
  initial_node_count       = 1

  release_channel {
    channel = var.release_channel
  }

  ip_allocation_policy {
    cluster_secondary_range_name  = var.pods_secondary_range_name
    services_secondary_range_name = var.services_secondary_range_name
  }

  private_cluster_config {
    enable_private_nodes    = true
    enable_private_endpoint = false
    master_ipv4_cidr_block  = var.master_ipv4_cidr_block
  }

  dynamic "master_authorized_networks_config" {
    for_each = length(var.master_authorized_networks) > 0 ? [1] : []
    content {
      dynamic "cidr_blocks" {
        for_each = var.master_authorized_networks
        content {
          cidr_block   = cidr_blocks.value.cidr_block
          display_name = cidr_blocks.value.display_name
        }
      }
    }
  }

  workload_identity_config {
    workload_pool = "${var.project_id}.svc.id.goog"
  }

  cluster_autoscaling {
    enabled = true

    auto_provisioning_defaults {
      service_account = var.node_service_account
      oauth_scopes    = ["https://www.googleapis.com/auth/cloud-platform"]
      disk_type       = "pd-standard"
    }

    resource_limits {
      resource_type = "cpu"
      minimum       = 1
      maximum       = 200
    }

    resource_limits {
      resource_type = "memory"
      minimum       = 4
      maximum       = 1024
    }
  }

  monitoring_config {
    managed_prometheus {
      enabled = true
    }
  }

  lifecycle {
    ignore_changes = [node_config]
  }
}

resource "google_container_node_pool" "system" {
  name       = "system-pool"
  project    = var.project_id
  location   = var.region
  cluster    = google_container_cluster.this.name
  node_count = var.system_pool_min_nodes

  autoscaling {
    min_node_count = var.system_pool_min_nodes
    max_node_count = var.system_pool_max_nodes
  }

  management {
    auto_repair  = true
    auto_upgrade = true
  }

  node_config {
    machine_type    = var.system_pool_machine_type
    service_account = var.node_service_account
    oauth_scopes    = ["https://www.googleapis.com/auth/cloud-platform"]

    workload_metadata_config {
      mode = "GKE_METADATA"
    }

    labels = {
      pool = "system"
    }
  }
}

resource "google_container_node_pool" "application" {
  name       = "application-pool"
  project    = var.project_id
  location   = var.region
  cluster    = google_container_cluster.this.name
  node_count = var.application_pool_min_nodes

  autoscaling {
    min_node_count = var.application_pool_min_nodes
    max_node_count = var.application_pool_max_nodes
  }

  management {
    auto_repair  = true
    auto_upgrade = true
  }

  node_config {
    machine_type    = var.application_pool_machine_type
    service_account = var.node_service_account
    oauth_scopes    = ["https://www.googleapis.com/auth/cloud-platform"]

    workload_metadata_config {
      mode = "GKE_METADATA"
    }

    labels = {
      pool = "application"
    }
  }
}
