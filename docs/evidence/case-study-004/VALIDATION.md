# Case Study #004 — Validation Record

## AI Usage Collection & Cost Attribution Pipeline

---

### Validation Objective

Prove that the mock AI Usage Collector can generate sample records and insert them into `ai_finops.ai_usage` using Cloud Run and Terraform-managed BigQuery permissions only.

---

### Validation Commands and Captured Outputs

```bash
cd platform/terraform/environments/dev

# Validate Terraform
terraform validate

# Review the initial plan
terraform plan -var-file=terraform.tfvars -var="budget_notification_email=<email>"

# Apply infrastructure
terraform apply -var-file=terraform.tfvars -var="budget_notification_email=<email>"

# Build and push the collector image to Artifact Registry
cd ../../..
cd services/ai-usage-collector
# docker build -t <artifact-registry-url>/ai-usage-collector:latest .
# docker push <artifact-registry-url>/ai-usage-collector:latest

# Apply again with the image URI set
cd ../../platform/terraform/environments/dev
terraform apply -var-file=terraform.tfvars -var="budget_notification_email=<email>" -var="ai_usage_collector_container_image=<artifact-registry-url>/ai-usage-collector:latest"

# Invoke Cloud Run health endpoint
curl <cloud-run-url>/

# Generate sample usage records
curl -X POST <cloud-run-url>/generate -H 'Content-Type: application/json' -d '{"count": 3}'

# Inspect collector stats
curl <cloud-run-url>/stats

# Verify records in BigQuery
bq query --use_legacy_sql=false 'SELECT COUNT(*) AS record_count FROM `aiopsvista-market-dev.ai_finops.ai_usage`'

# Destroy the environment
terraform destroy -var-file=terraform.tfvars -var="budget_notification_email=<email>"
```

### Captured Output Placeholders

Record the actual command output for each validation step below.

| Step | Capture |
| --- | --- |
| `terraform validate` | `[paste output here]` |
| `terraform plan` before image apply | `[paste output here]` |
| Initial `terraform apply` | `[paste output here]` |
| Image build and push | `[paste output here]` |
| Second `terraform apply` with image URI | `[paste output here]` |
| `curl <cloud-run-url>/healthz` | `[paste output here]` |
| `curl <cloud-run-url>/readyz` | `[paste output here]` |
| `curl -X POST <cloud-run-url>/generate` | `[paste output here]` |
| `curl <cloud-run-url>/stats` | `[paste output here]` |
| BigQuery row count query | `[paste output here]` |
| `terraform destroy` | `[paste output here]` |

---

### Success Criteria

- Terraform validation succeeds
- Cloud Run service is created
- Mock records are generated without calling external AI APIs
- Records are written into `ai_finops.ai_usage`
- `/healthz` returns service health
- `/readyz` passes startup and environment validation
- `/stats` returns inserted record counts
- BigQuery shows new rows in the table
- The environment can be destroyed cleanly

---

### Expected Validation Evidence

| Check | Expected Result |
| --- | --- |
| `terraform validate` | Success |
| `terraform plan` | No errors |
| `terraform apply` | Artifact Registry, service account, IAM, and Cloud Run resources created |
| `/healthz` | Health response with `status: ok` |
| `/readyz` | Readiness response with `status: ready` |
| `/generate` | Returns inserted record count and sample records |
| `/stats` | Returns inserted record counts |
| BigQuery query | Row count increases after `/generate` |
| `terraform destroy` | Resources removed cleanly |

---

### Evidence Collection Strategy

Collect the following artifacts during validation:

- Terraform plan output
- Terraform apply output
- Cloud Run service URL
- `/` response
- `/generate` response
- `/stats` response
- BigQuery query output showing inserted rows
- Terraform state list

The evidence should prove that the pipeline is repeatable, low cost, and ready for future OpenAI, Gemini, Claude, and agent integrations.
