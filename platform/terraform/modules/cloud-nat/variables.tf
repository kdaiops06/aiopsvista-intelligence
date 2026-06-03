variable "project_id" {
  description = "Project ID for Cloud NAT resources."
  type        = string
}

variable "region" {
  description = "Region for Cloud Router and NAT."
  type        = string
}

variable "network_self_link" {
  description = "Self link of the target VPC network."
  type        = string
}

variable "router_name" {
  description = "Cloud Router name."
  type        = string
  default     = "aiopsvista-cloud-router"
}

variable "nat_name" {
  description = "Cloud NAT name."
  type        = string
  default     = "aiopsvista-cloud-nat"
}
