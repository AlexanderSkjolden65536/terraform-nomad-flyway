output "flyway_service" {
  description = "Flyway service name"
  value       = data.template_file.nomad_job_flyway.vars.service_name
}

output "flyway_port" {
  description = "Flyway port number"
  value       = data.template_file.nomad_job_flyway.vars.port
}

output "flyway_host" {
  description = "Flyway host"
  value       = data.template_file.nomad_job_flyway.vars.host
}