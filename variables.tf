# Nomad
variable "nomad_datacenters" {
  type        = list(string)
  description = "Nomad data centers"
  default     = ["dc1"]
}
variable "nomad_namespace" {
  type        = string
  description = "[Enterprise] Nomad namespace"
  default     = "default"
}
# Flyway
variable "service_name" {
  type        = string
  description = "Flyway service name"
  default     = "flyway"
}
variable "host" {
  type        = string
  description = "Flyway host"
  default     = "127.0.0.1"
}
variable "port" {
  type        = number
  description = "Flyway port"
  default     = 6379
}
variable "container_image" {
  type        = string
  description = "Flyway docker image"
  default     = "flyway:flyway"
}
variable "resource" {
  type = object({
    cpu    = number,
    memory = number
  })
  default = {
    cpu    = 200,
    memory = 128
  }
  description = "Flyway resources. CPU and memory allocation."
  validation {
    condition     = var.resource.cpu >= 200 && var.resource.memory >= 128
    error_message = "Flyway resource must be at least: cpu=500, memory=1024."
  }
}
variable "resource_proxy" {
  type = object({
    cpu    = number,
    memory = number
  })
  default = {
    cpu    = 200,
    memory = 128
  }
  description = "Flyway proxy resources"
  validation {
    condition     = var.resource_proxy.cpu >= 200 && var.resource_proxy.memory >= 128
    error_message = "Proxy resource must be at least: cpu=200, memory=128."
  }
}

variable "use_canary" {
  type        = bool
  description = "Uses canary deployment for Flyway"
  default     = false
}