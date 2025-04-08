module "gcs" {
  source     = "../modules/gcs"
  buckets    = var.buckets
  # name       = var.name
  project_id = var.project_id
  # region     = var.region

}