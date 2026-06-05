# Terraform Bootstrap

## Purpose
This bootstrap layer prepares remote state infrastructure for Terraform in the `dev` environment.

## Remote State Bucket Requirements
- Google Cloud Storage bucket for Terraform state.
- Versioning enabled for state recovery.
- Uniform bucket-level access enabled.

## Recommended State Bucket
- Name: `aiopsvista-dev-tfstate` (globally unique suffix may be required)
- Location: `us-central1` or `US`
- Access: restricted IAM (principle of least privilege)

## State Locking Strategy
Terraform GCS backend uses object generation preconditions for optimistic locking. This prevents concurrent writers from overwriting the state unexpectedly.

Operational guidance:
- Run Terraform from controlled CI jobs or one operator session at a time.
- If lock conflicts occur, verify active runs before retrying.
- Do not manually edit state objects.

## Backend Example
See `backend.tf.example` for backend configuration template.
