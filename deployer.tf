locals {
  max_deployer_name_len = 30 - length("deployer--12345")
  deployer_name         = "deployer-${substr(local.block_ref, 0, local.max_deployer_name_len)}-${random_string.resource_suffix.result}"
}

resource "google_service_account" "deployer" {
  account_id   = local.deployer_name
  display_name = "Deployer for ${local.block_name}"
}

# Grant Cloud Functions Developer role to deploy and manage functions
resource "google_project_iam_member" "deployer_cloudfunctions_developer" {
  project = local.project_id
  role    = "roles/cloudfunctions.developer"
  member  = "serviceAccount:${google_service_account.deployer.email}"
}

# Grant Storage Object Admin role to upload source code
resource "google_project_iam_member" "deployer_storage_admin" {
  project = local.project_id
  role    = "roles/storage.objectAdmin"
  member  = "serviceAccount:${google_service_account.deployer.email}"
}

# Grant Service Account User role to allow the deployer to act as the function's service account
resource "google_project_iam_member" "deployer_service_account_user" {
  project = local.project_id
  role    = "roles/iam.serviceAccountUser"
  member  = "serviceAccount:${google_service_account.deployer.email}"
}

// Allow Nullstone Agent to impersonate the deployer account
resource "google_service_account_iam_binding" "deployer_nullstone_agent" {
  service_account_id = google_service_account.deployer.id
  role               = "roles/iam.serviceAccountTokenCreator"
  members            = ["serviceAccount:${local.ns_agent_service_account_email}"]
}
