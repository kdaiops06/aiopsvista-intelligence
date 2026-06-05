# Shared VPC Module

## Purpose
Creates the shared VPC and required private subnets for the landing zone foundation.

## Defaults
Network name:
- `aiopsvista-shared-vpc`

Subnets:
- `gke-subnet`
- `services-subnet`

Features:
- Private Google Access enabled for both subnets.
- Secondary IP ranges for Pods and Services on `gke-subnet`.

## Inputs
- `project_id`
- `region`
- `network_name`
- `subnets`

## Outputs
- `network_name`
- `network_self_link`
- `subnet_names`
- `subnet_self_links`
