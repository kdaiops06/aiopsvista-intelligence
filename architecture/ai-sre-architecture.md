# AiOpsVista AI Usage Collector SRE View

## Reliability Objectives

The AI Usage Collector is designed to be easy to operate and easy to troubleshoot.

### Controls Implemented

- Startup validation for `PROJECT_ID`, `DATASET_ID`, and `TABLE_ID`
- `GET /healthz` endpoint for service health
- `GET /readyz` endpoint for readiness validation
- Structured logging for startup, readiness, and BigQuery insert outcomes
- BigQuery success and failure logging with request identifiers

### Failure Handling

- Missing runtime configuration fails fast before the service is considered ready
- BigQuery insert failures return a clear 502 response
- Private access defaults reduce exposure risk and keep operational access deliberate

### Operational Runbook Topics

- Cloud Build source fetch failures
- Artifact Registry push failures
- Terraform service creation failures when the image URI is missing
- HTTP 403 responses from authenticated-only services
- Cloud Run destroy failures when deletion protection is enabled

### SRE Outcome

The service now supports a clean production-style lifecycle: deploy, validate, observe, troubleshoot, and destroy.
