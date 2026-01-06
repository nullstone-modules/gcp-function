locals {
  max_builder_name_len = 30 - length("builder--12345")
  builder_name         = "builder-${substr(local.block_ref, 0, local.max_builder_name_len)}-${random_string.resource_suffix.result}"
}

// The builder service account has enough permissions to build the code for the cloud function
resource "google_service_account" "builder" {
  account_id   = local.builder_name
  display_name = "Builder for cloud function ${local.block_name}"
}

// Allow cloud builder to impersonate the builder service account
resource "google_service_account_iam_member" "cloudbuild_impersonate_cf_build" {
  service_account_id = google_service_account.builder.name
  role               = "roles/iam.serviceAccountUser"
  member             = "serviceAccount:${local.project_number}@cloudbuild.gserviceaccount.com"
}

resource "google_project_iam_member" "builder_build" {
  project = local.project_id
  role    = "roles/cloudbuild.builds.builder"
  member  = "serviceAccount:${google_service_account.builder.email}"
}

resource "google_project_iam_member" "builder_publish_artifacts" {
  project = local.project_id
  role    = "roles/artifactregistry.writer"
  member  = "serviceAccount:${google_service_account.builder.email}"
}

resource "google_project_iam_member" "builder_code_access" {
  project = local.project_id
  role    = "roles/storage.objectViewer"
  member  = "serviceAccount:${google_service_account.builder.email}"
}
