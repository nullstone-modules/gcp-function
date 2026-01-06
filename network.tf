data "ns_connection" "network" {
  name     = "network"
  contract = "network/gcp/vpc"
}

locals {
  vpc_access_connector_id = data.ns_connection.network.outputs.vpc_access_connector_id
}
