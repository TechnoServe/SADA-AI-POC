terraform {
  backend "gcs" {
    bucket = "bkt-techno-tf"
    prefix = "terraform/state/techno-aipoc/gcs"
  }
}
