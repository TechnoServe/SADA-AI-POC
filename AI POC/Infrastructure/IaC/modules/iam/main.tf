
# Create Service Account
resource "google_service_account" "service_account" {
  account_id   = var.account_id
  display_name = var.display_name
}

# Assign IAM roles to the specified service account
resource "google_project_iam_member" "service_account_roles" {
  for_each = {
    for entry in flatten([
      for service_account, roles in var.service_account_roles_map : [
        for role in roles : {
          service_account = service_account
          role            = role
        }
      ]
    ]) : "${entry.service_account}-${entry.role}" => entry
  }

  project = var.project_id
  role    = each.value.role
  member  = "serviceAccount:${each.value.service_account}"
}

# Assign IAM roles to the specified user
resource "google_project_iam_member" "user_roles" {
  for_each = {
    for entry in flatten([
      for user, roles in var.user_roles_map : [
        for role in roles : {
          user = user
          role = role
        }
      ]
    ]) : "${entry.user}-${entry.role}" => entry
  }
  project = var.project_id
  role    = each.value.role
  member  = "user:${each.value.user}"
}




