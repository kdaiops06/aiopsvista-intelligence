# Case Study #004 Validation Checklist

## Terraform

- [x] `terraform init`
- [x] `terraform validate`
- [x] `terraform plan`
- [x] Initial `terraform apply`
- [x] Second `terraform apply` with `container_image`
- [x] `terraform destroy`

## Cloud Build and Artifact Registry

- [x] Cloud Build source fetch succeeded
- [x] Image build succeeded
- [x] Image push to Artifact Registry succeeded
- [x] Recorded image digest matches the published artifact

## Cloud Run

- [x] Service created successfully
- [x] Image configured as the deployed revision source
- [x] Service account attached to the runtime
- [x] Scaling set to min 0 / max 1
- [x] Concurrency configured to 20
- [x] Endpoint returns HTTP 403 when unauthenticated

## BigQuery

- [x] Dataset `ai_finops` confirmed
- [x] Table `ai_usage` confirmed
- [x] Daily partitioning confirmed
- [x] Clustering confirmed
- [x] Schema matches Case Study #003

## Evidence Handling

- [x] Terraform state captured before teardown
- [x] Cloud Run description captured before teardown
- [x] Cloud Build output captured before teardown
- [x] IAM policy captured before teardown
- [x] BigQuery schema captured before teardown
