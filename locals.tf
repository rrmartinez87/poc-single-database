/*
  Default values that must be provided according to architecture and can't be setteable from outside the module
*/

locals {
  public_network_access = false
  tls_version = "1.2"
  connection_type = "Redirect"
  service_endpoints = ["Microsoft.Sql"]
  enforce_private_link_endpoint_policies = true
  separator = "-"
  sample_database = "AdventureWorksLT"
}
