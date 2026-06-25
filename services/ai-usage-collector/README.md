# AI Usage Collector Service

The AI Usage Collector is the Phase 1 Cloud Run service for Case Study #004.

## Purpose

The service generates or accepts AI telemetry events, validates the required runtime configuration, normalizes the event payload, and writes the record to `ai_finops.ai_usage`.

## Runtime Contract

Environment variables:

- `PROJECT_ID`
- `DATASET_ID`
- `TABLE_ID`
- `DEFAULT_BATCH_SIZE`

Exposed endpoints:

- `GET /` - service health summary
- `GET /healthz` - health endpoint used for operational checks
- `GET /readyz` - readiness endpoint with startup/environment validation
- `POST /generate` - generate and insert sample usage records
- `GET /stats` - runtime counters for inserted records

## Operational Controls

- Dedicated Cloud Run service account
- Explicit CPU, memory, timeout, concurrency, and instance count controls
- BigQuery write access limited to `ai_finops.ai_usage`
- Authentication required by default
- Structured JSON logging for startup, readiness, insert success, and insert failure events

## Data Flow

1. A request arrives or sample data is generated.
2. Required environment variables are validated.
3. The record is normalized to the Case Study #003 schema.
4. BigQuery inserts the row into `ai_finops.ai_usage`.
5. The service logs success or failure with request identifiers.

## Deployment

The service is deployed from Artifact Registry via Terraform-managed Cloud Run resources.
