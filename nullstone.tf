terraform {
  required_providers {
    ns = {
      source = "nullstone-io/ns"
    }
  }
}

data "ns_workspace" "this" {}

data "ns_agent" "this" {}

locals {
  ns_agent_service_account_email = data.ns_agent.this.gcp_service_account_email
}

// Generate a random suffix to ensure uniqueness of resources
resource "random_string" "resource_suffix" {
  length  = 5
  lower   = true
  upper   = false
  numeric = false
  special = false
}

locals {
  labels        = { for k, v in data.ns_workspace.this.tags : lower(k) => v }
  block_ref     = data.ns_workspace.this.block_ref
  block_name    = data.ns_workspace.this.block_name
  resource_name = "${local.block_ref}-${random_string.resource_suffix.result}"
}
