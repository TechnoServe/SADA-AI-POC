
#GCS Bucket
resource "google_storage_bucket" "bkt-aipoc" {
  for_each                    = var.buckets
  name                        = each.key
  project                     = var.project_id
  location                    = each.value
  force_destroy               = true # Allows the bucket to be destroyed even if it contains objects. Use with caution.
  uniform_bucket_level_access = true
  storage_class               = "STANDARD"
}
