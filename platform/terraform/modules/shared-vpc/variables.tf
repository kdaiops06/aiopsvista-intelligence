variable "project_id" {
  description = "Project ID where VPC resources are created."
  type        = string
}

variable "region" {
  description = "Region for subnet creation."
  type        = string
}

variable "network_name" {
  description = "Shared VPC network name."
  type        = string
  default     = "aiopsvista-shared-vpc"
}

variable "subnets" {
  description = "Subnet definitions and secondary ranges."
  type = map(object({
    cidr                     = string
    private_ip_google_access = bool
    secondary_ranges         = map(string)
  }))

  default = {
    gke-subnet = {
      cidr                     = "10.10.0.0/20"
      private_ip_google_access = true
      secondary_ranges = {
        gke-pods-range     = "10.20.0.0/16"
        gke-services-range = "10.30.0.0/20"
      }
    }
    services-subnet = {
      cidr                     = "10.10.16.0/20"
      private_ip_google_access = true
      secondary_ranges         = {}
    }
  }
}
