resource "google_project" "this" {
  name            = var.project_name
  project_id      = var.project_id
  billing_account = var.billing_account

  org_id    = var.org_id
  folder_id = var.folder_id
}

resource "google_project_service" "enabled" {
  for_each = toset(var.activate_apis)

  project            = google_project.this.project_id
  service            = each.value
  disable_on_destroy = false
}
