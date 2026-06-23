# Case Study #004 — Implementation Record

## AI Usage Collection & Cost Attribution Pipeline

---

### Environment

| Property | Value |
| --- | --- |
| Branch | `feature/case-study-004-ai-usage-collector` |
| Project | `aiopsvista-market-dev` |
| Region | `us-central1` |
| Dataset | `ai_finops` |
| Table | `ai_usage` |
| Runtime | `Cloud Run` |
| Storage | `BigQuery` |

---

### Terraform Module

| Resource | Purpose |
| --- | --- |
| `platform/terraform/modules/ai-usage-collector` | Reusable Phase 1 collector module |
| `google_artifact_registry_repository.ai_usage_collector` | Container image repository |
| `google_service_account.ai_usage_collector` | Least-privilege runtime identity |
| `google_bigquery_table_iam_member.ai_usage_writer` | Write access limited to `ai_finops.ai_usage` |
| `google_cloud_run_v2_service.ai_usage_collector` | Mock collector runtime |
| `google_cloud_run_v2_service_iam_member.public_invoker` | Public invocation for lightweight validation |

---

### Dev Environment Integration

| File | Change |
| --- | --- |
| `platform/terraform/environments/dev/main.tf` | Added `run.googleapis.com` and module wiring for the collector |
| `platform/terraform/environments/dev/variables.tf` | Added collector image and configuration variables |
| `platform/terraform/environments/dev/outputs.tf` | Added collector service and repository outputs |
| `platform/terraform/environments/dev/terraform.tfvars.example` | Added collector image example value |

---

### Mock Collector Application

| File | Purpose |
| --- | --- |
| `services/ai-usage-collector/app/main.py` | FastAPI service with `/`, `/generate`, and `/stats` endpoints |
| `services/ai-usage-collector/Dockerfile` | Container image for Cloud Run deployment |
| `services/ai-usage-collector/requirements.txt` | Python dependencies |

---

### Data Flow

1. Cloud Run receives a request.
2. The collector generates or normalizes sample usage data.
3. The collector writes rows to `ai_finops.ai_usage`.
4. `/stats` returns the current inserted record counts for the active instance.

---

### Sample Event Fields

The collector writes the following fields into the BigQuery schema from Case Study #003:

- `event_timestamp`
- `provider`
- `model`
- `request_id`
- `user_id`
- `project_id`
- `team_name`
- `workflow_name`
- `agent_name`
- `request_count`
- `input_tokens`
- `output_tokens`
- `total_tokens`
- `estimated_cost`
- `latency_ms`
- `status`
- `environment`

---

### Security Controls

- No OpenAI, Gemini, or Claude API keys are required in Phase 1.
- Cloud Run runtime identity is isolated to the collector service.
- BigQuery write access is scoped to the `ai_usage` table only.
- The collector uses Terraform-managed IAM and service configuration.

---

### Recommended Validation Sequence

1. `terraform validate`
2. `terraform plan`
3. `terraform apply` to create the repository, IAM, and service scaffolding
4. Build and push the collector image to Artifact Registry
5. `terraform apply` again with the image URI set
6. Invoke `/`
7. Invoke `/generate`
8. Invoke `/stats`
9. Query BigQuery to confirm inserted records
10. `terraform destroy`
