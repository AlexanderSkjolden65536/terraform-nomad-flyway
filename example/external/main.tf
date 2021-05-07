module "flyway" {
  source = "../.."

  depends_on = [
    module.postgres
  ]

  # nomad
  nomad_datacenters = ["dc1"]
  nomad_namespace   = "default"

  # flyway
  service_name    = "flyway"
  host            = "127.0.0.1"
  container_image = "flyway/flyway"
  use_canary      = false
  resource_proxy = {
    cpu    = 200
    memory = 128
  }

  jdbc = {
    host      = module.postgres.service_name
    port      = module.postgres.port
    protocol  = "postgresql"
    username  = module.postgres.username
    password  = module.postgres.password
    database  = module.postgres.database_name
    schema    = "public"
  }
}

module "postgres" {
  source = "github.com/skatteetaten/terraform-nomad-postgres.git?ref=0.4.1"

  # nomad
  nomad_datacenters = ["dc1"]
  nomad_namespace   = "default"

  # postgres
  service_name    = "postgres"
  container_image = "postgres:12-alpine"
  container_port  = 5432
  vault_secret = {
    use_vault_provider      = false,
    vault_kv_policy_name    = "",
    vault_kv_path           = "",
    vault_kv_field_username = "",
    vault_kv_field_password = ""
  }
  admin_user                      = "postgres"
  admin_password                  = "postgres"
  database                        = "test"
  volume_destination              = "/var/lib/postgresql/data"
  use_host_volume                 = false
  use_canary                      = false
  container_environment_variables = ["PGDATA=/var/lib/postgresql/data/"]
}