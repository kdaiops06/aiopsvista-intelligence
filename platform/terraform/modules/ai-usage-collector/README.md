# ai-usage-collector Terraform Module

This module provisions the Phase 1 AI Usage Collector foundation for Case Study #004.

## What it creates

- Artifact Registry repository for the collector container image
- Cloud Run service account with least-privilege BigQuery write access
- BigQuery table IAM binding limited to `ai_finops.ai_usage`
- Cloud Run v2 service when a container image URI is provided
- Optional public invoker binding when `public_access = true`

## Inputs

| Variable | Purpose |
| --- | --- |
| `project_id` | GCP project that hosts the collector |
| `region` | Region for Artifact Registry and Cloud Run |
| `dataset_id` | BigQuery dataset ID (`ai_finops`) |
| `table_id` | BigQuery table ID (`ai_usage`) |
| `service_name` | Cloud Run service name (`ai-usage-collector`) |
| `service_account_id` | Runtime service account ID |
| `artifact_registry_repository_id` | Docker repository ID |
| `container_image` | Image URI for the Cloud Run service |
| `public_access` | Allow unauthenticated invocation (`false` by default) |
| `container_port` | Exposed container port |
| `default_batch_size` | Default sample insert batch size |
| `cpu` | Cloud Run CPU limit |
| `memory` | Cloud Run memory limit |
| `request_timeout_seconds` | Cloud Run request timeout |
| `concurrency` | Max request concurrency per instance |
| `max_instance_count` | Max Cloud Run instance count |
| `labels` | Governance labels |

## Outputs

| Output | Purpose |
| --- | --- |
| `service_account_email` | Runtime identity used by Cloud Run |
| `artifact_registry_repository_url` | Docker image base URL |
| `service_url` | Cloud Run endpoint URI |

## Validation pattern

1. Apply the module once to create the repository and IAM bindings.
2. Build and push the collector image to the repository.
3. Apply again with `container_image` set to the pushed image URI.
4. Invoke `/`, `/generate`, and `/stats`.
5. Verify rows in `ai_finops.ai_usage`.
