module "flyway" {
  source = "../.."

  # nomad
  nomad_datacenters = ["dc1"]
  nomad_namespace   = "default"

  # flyway
  service_name    = "flyway"
  host            = "127.0.0.1"
  port            = 6379
  container_image = "flyway:flyway"
  use_canary      = false
  resource_proxy = {
    cpu    = 200
    memory = 128
  }

}