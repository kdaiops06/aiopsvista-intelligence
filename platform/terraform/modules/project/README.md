# Project Module

## Purpose
Creates a Google Cloud project and enables required platform APIs.

## APIs Enabled By Default
- compute.googleapis.com
- container.googleapis.com
- iam.googleapis.com
- cloudresourcemanager.googleapis.com
- artifactregistry.googleapis.com

## Inputs
- `project_name`
- `project_id`
- `billing_account`
- `org_id` (optional)
- `folder_id` (optional)
- `activate_apis`

## Outputs
- `project_id`
- `project_number`
- `enabled_apis`
