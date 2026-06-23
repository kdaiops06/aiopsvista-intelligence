variable "project_id" {
  description = "GCP project ID that hosts the collector."
  type        = string
}

variable "region" {
  description = "Region for Artifact Registry and Cloud Run."
  type        = string
}

variable "dataset_id" {
  description = "BigQuery dataset ID that stores AI usage records."
  type        = string
  default     = "ai_finops"
}

variable "table_id" {
  description = "BigQuery table ID that stores AI usage records."
  type        = string
  default     = "ai_usage"
}

variable "service_name" {
  description = "Cloud Run service name."
  type        = string
  default     = "ai-usage-collector"
}

variable "service_account_id" {
  description = "Service account ID for the Cloud Run runtime identity."
  type        = string
  default     = "ai-usage-collector"
}

variable "artifact_registry_repository_id" {
  description = "Artifact Registry repository ID for the collector image."
  type        = string
  default     = "ai-usage-collector"
}

variable "container_image" {
  description = "Container image URI for the Cloud Run service. Leave empty until the image is built and pushed."
  type        = string
  default     = ""
}

variable "public_access" {
  description = "Allow unauthenticated invocations of the mock collector."
  type        = bool
  default     = false
}

variable "container_port" {
  description = "Container port exposed by the collector service."
  type        = number
  default     = 8080
}

variable "default_batch_size" {
  description = "Default number of mock records to generate per request."
  type        = number
  default     = 3
}

variable "cpu" {
  description = "CPU limit for the Cloud Run service."
  type        = string
  default     = "1"
}

variable "memory" {
  description = "Memory limit for the Cloud Run service."
  type        = string
  default     = "512Mi"
}

variable "request_timeout_seconds" {
  description = "Request timeout for the Cloud Run service in seconds."
  type        = number
  default     = 300
}

variable "concurrency" {
  description = "Maximum concurrent requests per Cloud Run instance."
  type        = number
  default     = 20
}

variable "max_instance_count" {
  description = "Maximum number of Cloud Run instances."
  type        = number
  default     = 1
}

variable "labels" {
  description = "Standard governance labels for collector resources."
  type        = map(string)
  default = {
    environment = "dev"
    platform    = "aiopsvista"
    managed_by  = "terraform"
    cost_center = "ai-finops"
  }
}
