locals {
  function_name          = local.resource_name
  use_bootstrap_artifact = local.app_version == ""
  effective_runtime      = local.use_bootstrap_artifact ? "go125" : var.runtime
  effective_entrypoint   = local.use_bootstrap_artifact ? "bootstrap" : var.entrypoint
  effective_source_key   = local.use_bootstrap_artifact ? google_storage_bucket_object.bootstrap.name : local.current_artifact_key
}

resource "google_cloudfunctions2_function" "function" {
  depends_on = [
    google_project_service.run,
    google_project_service.cloudbuild,
    google_project_service.function,
    google_project_service.artifact_registry,
    google_project_iam_member.builder_build,
    google_project_iam_member.builder_publish_artifacts,
    google_project_iam_member.builder_code_access,
  ]

  name        = local.function_name
  location    = local.region
  description = "${local.resource_name} - Managed by Nullstone"
  labels      = local.labels

  build_config {
    runtime         = local.effective_runtime
    entry_point     = local.effective_entrypoint
    service_account = google_service_account.builder.id

    environment_variables = {}

    source {
      storage_source {
        bucket = google_storage_bucket.source_code.name
        object = local.effective_source_key
      }
    }
  }

  service_config {
    service_account_email            = google_service_account.app.email
    available_cpu                    = var.cpu
    available_memory                 = var.memory
    timeout_seconds                  = var.timeout
    max_instance_count               = var.max_instances
    max_instance_request_concurrency = var.max_request_concurrency
    all_traffic_on_latest_revision   = true
    ingress_settings                 = "ALLOW_INTERNAL_AND_GCLB"
    vpc_connector_egress_settings    = "ALL_TRAFFIC"
    vpc_connector                    = local.vpc_access_connector_id

    environment_variables = local.all_env_vars

    dynamic "secret_environment_variables" {
      for_each = local.all_secrets
      iterator = secretRef

      content {
        key        = secretRef.key
        project_id = local.project_id
        secret     = secretRef.value
        version    = "latest"
      }
    }
  }
}
