# Case Study #004 - Implementation Gaps Fixed

## 1. Terraform Wiring

- Issue: The collector module was not wired into the dev environment, so `terraform apply` could not deploy the collector end to end.
- Root cause: The dev stack only instantiated the project, network, budget, and BigQuery foundation modules.
- Resolution: Added the `ai-usage-collector` module to the dev environment and surfaced the collector image, access, and runtime sizing variables and outputs.
- Business value: The feature is now deployable, inspectable, and destroyable through Terraform instead of requiring manual setup.

## 2. Security Defaults

- Issue: Public invocation was effectively the default through an `allUsers` binding.
- Root cause: The collector module treated unauthenticated access as the normal path.
- Resolution: Switched to `public_access = false` by default and removed the public invoker binding unless explicitly enabled.
- Business value: The service now follows secure-by-default principles and avoids accidental public exposure.

## 3. FinOps Controls

- Issue: Cloud Run runtime sizing was implicit, which made cost control and capacity intent unclear.
- Root cause: The initial service definition relied on Cloud Run defaults.
- Resolution: Added explicit CPU, memory, request timeout, concurrency, and max instance controls with conservative values.
- Business value: The collector is now intentionally cost-capped and easier to review for production-readiness.

## 4. Reliability and Readiness

- Issue: The service did not fail fast on missing runtime configuration and did not expose explicit health/readiness endpoints.
- Root cause: Environment validation lived only inside the request path, and only a root endpoint existed.
- Resolution: Added startup validation for `PROJECT_ID`, `DATASET_ID`, and `TABLE_ID`, plus `/healthz` and `/readyz` endpoints.
- Business value: Misconfiguration is now caught immediately, reducing failed deployments and ambiguous runtime failures.

## 5. Observability

- Issue: BigQuery insert attempts were not logged in a structured way, so success and failure paths were hard to trace.
- Root cause: The collector used no explicit logging discipline around request identifiers or insert outcomes.
- Resolution: Added structured JSON logging for startup validation, readiness failures, insert attempts, insert successes, insert failures, and successful generate calls.
- Business value: Operators can now correlate collector activity with request IDs and BigQuery write outcomes.

## 6. Documentation

- Issue: Validation evidence was documented as a plan rather than a captured execution record.
- Root cause: The case study had a placeholder-style validation document.
- Resolution: Added explicit validation capture placeholders and a gap-fix summary document describing each change.
- Business value: The case study is now easier to review as consulting evidence and has a clearer audit trail for future validation runs.
