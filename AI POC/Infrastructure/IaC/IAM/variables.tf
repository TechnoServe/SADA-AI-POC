variable "project_id" {
  description = "GCP project ID"
  type        = string
}

variable "service_account_roles_map" {
  description = "Mapping of service accounts to their specific IAM roles"
  type        = map(list(string))
}


variable "user_roles_map" {
  description = "Mapping of users to their specific IAM roles"
  type        = map(list(string))
}


