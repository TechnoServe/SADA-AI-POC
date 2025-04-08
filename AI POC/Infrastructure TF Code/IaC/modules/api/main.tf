# Enable required APIs
resource "google_project_service" "enabled_apis" {
  for_each           = toset(var.api_services)
  project            = var.project_id
  service            = each.value
  disable_on_destroy = false
}