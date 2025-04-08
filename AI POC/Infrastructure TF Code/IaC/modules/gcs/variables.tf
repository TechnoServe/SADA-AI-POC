variable "project_id" {
  type        = string
  description = "project ID"

}

variable "buckets" {
  description = "A map of bucket names and their configurations"
  type        = map(string)
}