# AiOpsVista Case Study #004

## AI Usage Collection & Cost Attribution Pipeline

---

### 1. Executive Summary

Case Study #004 introduces a lightweight AI Usage Collector that populates the `ai_finops.ai_usage` BigQuery table established in Case Study #003.

This case study does not attempt to solve every provider integration problem at once. It starts with a mock collector that generates sample usage events, normalizes them, and writes them into BigQuery. That decision keeps costs near zero while proving that the platform can support AI FinOps, AI Cost Attribution, AI Observability, AI Reliability Engineering, and Agent Operations.

The strategic value of this case study is simple: it turns the Case Study #003 data model from a static foundation into a usable pipeline.

---

### 2. Business Problem

Organizations are increasingly using multiple AI providers and AI-enabled development tools, yet they still lack a centralized way to collect usage events and normalize them into a common cost model.

This creates predictable gaps:

- no single view of AI usage across providers,
- no normalized schema for downstream analysis,
- no consistent cost attribution by team or workflow,
- no way to measure the reliability cost of failed requests,
- no reusable ingestion pattern for internal AI agent platforms.

Case Study #003 created the storage foundation. Case Study #004 provides the collection path that makes the foundation operational.

---

### 3. Why This Case Study Exists

A BigQuery table is useful only when records are written to it.

Case Study #004 establishes the simplest possible collector that can generate or accept sample usage events and write them to `ai_finops.ai_usage`. That collector becomes the reference pattern for future provider-specific integrations.

This is a deliberate Phase 1 design:

- no external provider API calls,
- no complex orchestration,
- no message broker,
- no data processing pipeline,
- no platform sprawl.

The purpose is to prove the architecture, not to maximize feature count.

---

### 4. Architecture Summary

The target architecture is intentionally short:

**Cloud Run Service**

↓

**Normalize Event**

↓

**BigQuery `ai_finops.ai_usage`**

The mock collector generates sample usage events with the following model:

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

### 5. Case Study #003 Dependency

Case Study #004 consumes the foundation created in Case Study #003 in three ways:

| Case Study #003 Deliverable | Case Study #004 Dependency |
| --- | --- |
| `ai_finops` BigQuery dataset | Destination container for usage records |
| `ai_usage` BigQuery table | Normalized event target for the collector |
| `team_name`, `workflow_name`, `request_id`, `status` columns | Required metadata for attribution and reliability |
| Partitioning and clustering design | Cost-efficient query pattern for validation and reporting |
| Terraform-managed governance | Reproducible deployment and controlled lifecycle |

The collector is therefore not a separate initiative. It is the operational companion to the data model already established in the previous case study.

---

### 6. Phase 1 Scope

The scope for this case study is intentionally limited.

### In Scope

- Mock AI Usage Collector on Cloud Run
- Sample usage event generation
- Normalization to the Case Study #003 schema
- Insert sample rows into `ai_finops.ai_usage`
- Terraform-managed infrastructure

### Out of Scope

- Real OpenAI API calls
- Real Gemini API calls
- Real Claude API calls
- Kafka
- Pub/Sub
- Dataflow
- GKE
- Vertex AI
- Real-time dashboards

---

### 7. Recommended Terraform Architecture

The architecture should remain simple and low-cost.

### Proposed Resources

| Resource | Purpose |
| --- | --- |
| `google_cloud_run_v2_service` | Host the mock AI Usage Collector |
| `google_service_account` | Runtime identity for the collector |
| `google_project_iam_member` or dataset IAM binding | Grant write access to BigQuery |
| Optional `google_storage_bucket` | Store sample artifacts only if needed |

### Proposed Module Pattern

| Module | Purpose |
| --- | --- |
| `cloud-run-ai-usage-collector` | Deploys the mock collector |
| `bigquery-ai-finops` | Receives the normalized usage events |
| `project` | Enables APIs and supports runtime identity |

### Design Constraints

- Keep the collector serverless
- Keep the path batch-like, not streaming-first
- Keep dependencies minimal
- Keep costs near zero
- Keep the deployment Terraform-managed

---

### 8. Validation Strategy

Validation should prove the full path without requiring real provider integrations.

### Functional Checks

- Cloud Run service deploys successfully
- Mock collector generates sample usage events
- Records are written to `ai_finops.ai_usage`
- Rows include the required attribution and reliability fields
- Query results match the expected schema

### Terraform Checks

- `terraform init`
- `terraform validate`
- `terraform plan`
- `terraform apply`
- `terraform state list`

### Data Checks

- Required fields are populated
- `request_id` exists for traceability
- `team_name` and `workflow_name` are present when attribution data is available
- `status` and `latency_ms` are populated for reliability analysis
- Partition and clustering remain aligned with the Case Study #003 design

### Success Criteria

- Mock collector is running on Cloud Run
- Sample rows are inserted into BigQuery
- Terraform manages the entire deployment
- The collector can be replaced later with provider-specific integrations without redesigning the storage model

---

### 9. Evidence Collection Strategy

Evidence should support architecture reviews and portfolio demonstrations.

### Evidence to Capture

- Terraform state listing deployed resources
- Cloud Run service details
- BigQuery dataset confirmation
- BigQuery table confirmation
- Example inserted rows or query output
- Validation command output

### Evidence Rules

- Prefer command output over screenshots
- Do not store provider secrets
- Keep evidence reproducible
- Capture only what is needed to prove the architecture

---

### 10. Business Outcomes

If implemented as designed, Case Study #004 will deliver the following outcomes:

- AI usage events can be collected into a single warehouse,
- AI cost attribution becomes queryable by team, workflow, project, and agent,
- AI observability metadata becomes available for trace correlation,
- AI reliability metrics can be computed from the same dataset,
- the platform gains a reusable foundation for OpenAI, Gemini, Claude, and internal agents.

---

### 11. Architectural Positioning

Case Study #004 moves AiOpsVista from a data foundation to a data pipeline.

That transition enables the platform to support:

- **AI FinOps** through normalized cost and usage capture,
- **AI Cost Attribution** through team and workflow metadata,
- **AI Observability** through `request_id` and `status`,
- **AI Reliability Engineering** through latency and outcome fields,
- **Agent Operations** through `agent_name` and workflow attribution.

---

### 12. Future Expansion

The roadmap is intentionally phased:

- Phase 1 — Mock Collector
- Phase 2 — OpenAI Integration
- Phase 3 — Gemini Integration
- Phase 4 — Claude Integration
- Phase 5 — Agent Framework Integration
- Phase 6 — Real-Time Analytics

Each phase should build on the same schema rather than introducing a new data model.

---

### 13. Case Study Skeleton

The next implementation step should include:

- Terraform module for the Cloud Run collector,
- sample payload generator,
- BigQuery write path,
- evidence collection output,
- validation and rollback notes,
- updated architecture and case study evidence.

---

### 14. Technical Appendix

**Primary source of truth:** `docs/architecture/ai-finops/AI_USAGE_COLLECTOR_ARCHITECTURE.md`

**Roadmap:** `docs/architecture/ai-finops/AI_USAGE_COLLECTION_ROADMAP.md`

**Foundation dependency:** `docs/case-studies/case-study-003-ai-finops-foundation.md`

**Destination table:** `aiopsvista-market-dev.ai_finops.ai_usage`
