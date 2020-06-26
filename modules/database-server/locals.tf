/*
  Default values that must be provided according to architecture and can't be setteable from outside the module,
  or values that can be reused along the module.
*/

locals {

    // The version for the new server. Valid values are: 2.0 (for v11 server) and 12.0 (for v12 server).
    server_version = "12.0"

    // Flag to indicate whether to deny public access network.
    public_network_access = false

    // The server minimal TLS version needed.
    tls_version = "1.2"

    // Server connection policy setting, this one reduces latency and improves throughput.
    connection_type = "Redirect"

    // Type of content for the server admin secret.
    server_admin_secret_content_type = "SQL Server Admin"
    
  /* TODO:
  service_endpoints = ["Microsoft.Sql"]
  enforce_private_link_endpoint_policies = true
  */

}