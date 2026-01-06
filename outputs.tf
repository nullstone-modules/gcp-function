output "project_id" {
  value       = local.project_id
  description = "string ||| The GCP Project ID where this application is hosted."
}

output "function_id" {
  value       = google_cloudfunctions2_function.function.id
  description = "string ||| The ID of the Cloud Function (projects/{project_id}/locations/{location}/functions/{function_name})"
}

output "function_name" {
  value       = local.function_name
  description = "string ||| The name of the Cloud Function"
}

output "function_runtime" {
  value       = var.runtime
  description = "string ||| The desired runtime of the Cloud Function"
}

output "function_entrypoint" {
  value       = var.entrypoint
  description = "string ||| The desired entrypoint of the Cloud Function"
}

output "artifacts_bucket_id" {
  value       = google_storage_bucket.source_code.id
  description = "string ||| The ID of the GCS bucket holding source code."
}

output "artifacts_bucket_name" {
  value       = google_storage_bucket.source_code.name
  description = "string ||| The name of the GCS bucket holding source code."
}

output "artifacts_key_template" {
  value       = local.artifacts_key_template
  description = "string ||| Template for GCS object key that is used for Cloud function ({{app-version}} should be replaced with the app-version)"
}

output "deployer" {
  value = {
    project_id  = local.project_id
    email       = try(google_service_account.deployer.email, "")
    impersonate = true
  }

  description = "object({ email: string, impersonate: bool }) ||| A GCP service account with explicit privilege to deploy this Cloud function."
}

output "log_provider" {
  value       = "cloudlogging"
  description = "string ||| The log provider used for this service."
}

output "log_reader" {
  value = {
    project_id  = local.project_id
    email       = try(google_service_account.log_reader.email, "")
    impersonate = true
  }

  description = "object({ email: string, impersonate: bool }) ||| A GCP service account with explicit privilege to stream logs from this Cloud Run Job."
}

output "log_filter" {
  value       = "resource.type=\"cloud_run_revision\" AND resource.labels.service_name=\"${local.function_name}\""
  description = "string ||| A log filter used to filter Cloud Logging entries for this Cloud Function"
}

output "private_urls" {
  value       = local.private_urls
  description = "list(string) ||| A list of URLs only accessible inside the network"
}

output "public_urls" {
  value       = local.public_urls
  description = "list(string) ||| A list of URLs accessible to the public"
}
