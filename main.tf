locals {
  datacenters = join(",", var.nomad_datacenters)
}

data "template_file" "nomad_job_flyway" {
  template = var.mode == "memory" ? file("${path.module}/nomad/flyway_memory.hcl") : file("${path.module}/nomad/flyway_external.hcl")
  vars = {
    datacenters    = local.datacenters
    namespace      = var.nomad_namespace
    image          = var.container_image
    service_name   = var.service_name
    host           = var.host
    cpu            = var.resource.cpu
    memory         = var.resource.memory
    cpu_proxy      = var.resource_proxy.cpu
    memory_proxy   = var.resource_proxy.memory
    use_canary     = var.use_canary
    jdbc_host      = var.jdbc.host
    jdbc_port      = var.jdbc.port
    jdbc_protocol  = var.jdbc.protocol
    jdbc_username  = var.jdbc.username
    jdbc_password  = var.jdbc.password
    jdbc_database  = var.jdbc.database
    jdbc_schema    = var.jdbc.schema
  }
}

resource "nomad_job" "nomad_job_flyway" {
  jobspec = data.template_file.nomad_job_flyway.rendered
  detach  = false
}