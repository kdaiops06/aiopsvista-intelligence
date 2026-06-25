# AiOpsVista Market Intelligence Platform
A production-inspired AI Reliability Engineering reference platform built on Google Cloud Platform.

The project demonstrates how modern AI-powered systems can be designed, deployed, observed, operated, and continuously improved using cloud-native architecture, Kubernetes, Site Reliability Engineering (SRE), AI observability, agent operations, and operational governance.

## Why This Project Exists
Most AI demos stop at generating outputs.

This platform focuses on operating AI systems in production by exploring:

- AI Reliability Engineering
- AI Observability
- Agent Operations
- Incident Management
- Cloud Platform Engineering
- Kubernetes Operations
- Production AI Architectures

The market intelligence use case provides realistic data streams, operational scenarios, and AI workflows for demonstrating these concepts.

## Core Technology Areas

### Cloud Platform

- Google Cloud Platform (GCP)
- Shared VPC
- Private GKE
- Terraform

### Data Platform

- Pub/Sub
- BigQuery
- Cloud Storage

### AI Platform

- Vertex AI
- Gemini
- AI Agents

### Observability

- OpenTelemetry
- Prometheus
- Grafana
- Tempo

### AI Observability

- Langfuse
- OpenLIT

### Reliability Engineering

- SLIs
- SLOs
- Error Budgets
- Incident Response
- Operational Runbooks

## Long-Term Vision
Build a consulting-grade reference architecture demonstrating how enterprise AI systems can be:

- Designed
- Deployed
- Observed
- Troubleshot
- Secured
- Governed
- Operated at scale

This repository serves as:

- AI Reliability Engineering Lab
- GCP Reference Architecture
- Kubernetes Operations Playground
- AI Observability Demonstration Platform
- AiOpsVista Consulting Showcase
- Future Agent Operations Testbed

## Delivery Progress

The AiOpsVista case study series now follows this progression:

Provision -> Govern -> Observe -> Collect -> Attribute

Completed case studies:

- [Case Study #001](docs/case-studies/case-study-001-gke-landing-zone.md) - GCP Foundation Platform
- [Case Study #002](docs/case-studies/case-study-002-finops-budget-guardrails.md) - FinOps Budget Governance
- [Case Study #003](docs/case-studies/case-study-003-ai-finops-foundation.md) - AI FinOps Data Model
- [Case Study #004](docs/case-studies/case-study-004-ai-usage-collector-platform.md) - AI Usage Collector Platform

Next planned case study:

- Case Study #005 - AI FinOps Analytics & Executive Dashboard

## Start Here
If you are new to the repository, read these in order:

- [docs/PROJECT_CONTEXT.md](docs/PROJECT_CONTEXT.md)
- [docs/ARCHITECTURE.md](docs/ARCHITECTURE.md)
- [docs/ONBOARDING.md](docs/ONBOARDING.md)
- [docs/SDLC_AND_GOVERNANCE.md](docs/SDLC_AND_GOVERNANCE.md)
- [docs/WORKFLOW_CATALOG.md](docs/WORKFLOW_CATALOG.md)

For the AI FinOps track, also review:

- [docs/case-studies/README.md](docs/case-studies/README.md)
- [docs/architecture/ai-finops/AI_FINOPS_ARCHITECTURE.md](docs/architecture/ai-finops/AI_FINOPS_ARCHITECTURE.md)
- [docs/architecture/ai-finops/AI_USAGE_COLLECTOR_ARCHITECTURE.md](docs/architecture/ai-finops/AI_USAGE_COLLECTOR_ARCHITECTURE.md)

## Repository Snapshot
This repository is organized around documentation, platform foundations, and future implementation work.

- `architecture/` - architecture views and reference diagrams
- `content/` - reusable educational and consulting content
- `dashboards/` - dashboard assets and future operational views
- `docs/` - core project, governance, onboarding, and traceability documentation
- `incidents/` - incident scenarios and response materials
- `observability/` - telemetry and observability stack assets
- `platform/` - infrastructure and platform foundation work
- `roadmap/` - phase-by-phase execution planning
- `runbooks/` - operational procedures and recovery guidance
- `services/` - market intelligence service implementation area

## Contribution Guidelines
- Use feature branches for all work.
- Open a pull request for review before merging.
- Include documentation updates when behavior, architecture, or governance changes.
- Follow the PR template in [.github/pull_request_template.md](.github/pull_request_template.md).

## What This Repository Is Not
This is not a generic CRUD application, a SaaS starter, or a UI-first project.

It is intentionally focused on:

- Reliability
- Observability
- Automation
- Operability
- Educational value

## Audience
This repository is intended for:

- New engineers
- Contributors
- AI coding assistants
- Consultants
