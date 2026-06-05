# GKE Module

## Purpose
Creates a regional private GKE cluster for the landing-zone foundation.

## Features
- Regional cluster in `us-central1` (or provided region)
- Private nodes enabled
- Master authorized networks support
- Workload Identity enabled
- Cluster autoscaler enabled
- Node auto provisioning enabled via cluster autoscaling defaults
- Managed Prometheus enabled
- Release channel set to `REGULAR` by default
- Node pools:
  - `system-pool`
  - `application-pool`

## Security Baseline
- Private nodes
- Workload Identity
- Master authorized network controls

## Inputs
See `variables.tf` for configurable values.

## Outputs
- `cluster_name`
- `cluster_endpoint`
- `cluster_ca_certificate`
- `workload_identity_pool`
