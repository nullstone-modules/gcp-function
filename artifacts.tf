locals {
  storage_location       = local.region_prefix == "us" ? "US" : (local.region_prefix == "eu" ? "EU" : "ASIA")
  artifacts_bucket_name  = "artifacts-${local.resource_name}"
  artifacts_key_template = "function-{{app-version}}.zip"
  current_artifact_key   = "function-${local.app_version}.zip"
}

resource "google_storage_bucket" "source_code" {
  name                        = local.artifacts_bucket_name
  location                    = local.storage_location
  labels                      = local.labels
  uniform_bucket_level_access = true
  force_destroy               = true
}

resource "google_storage_bucket_object" "bootstrap" {
  bucket = google_storage_bucket.source_code.name
  name   = "bootstrap.zip"
  source = data.archive_file.bootstrap.output_path
}
