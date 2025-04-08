variable "project_id" {
  type        = string
  description = "project ID"

}

variable "api_services" {
  description = "List of GCP services to enable"
  type        = list(string)
}