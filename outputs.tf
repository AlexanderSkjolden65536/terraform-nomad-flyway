output "flyway_service" {
  description = "Flyway service name"
  value       = data.template_file.nomad_job_flyway.vars.service_name
}

output "flyway_host" {
  description = "Flyway host"
  value       = data.template_file.nomad_job_flyway.vars.host
}