job "flyway" {
  type        = "batch"
  datacenters = ["${datacenters}"]
  namespace   = "${namespace}"

  group "flyway" {
    count = 1
    network {
      mode = "bridge"
    }

    service {
      name = "${service_name}"
      check {
        type     = "script"
        name     = "Flyway alive"
        task     = "flyway-service"
        command  = "flyway-cli"
        args     = ["ping"]
        interval = "5s"
        timeout  = "5s"
      }
      connect {
        sidecar_service {
          proxy {
            upstreams {
              destination_name = "${jdbc_host}"
              local_bind_port  = "${jdbc_port}"
            }
          }
        }
        sidecar_task {
          resources {
            cpu     = "${cpu_proxy}" # MHz
            memory  = "${memory_proxy}" #MB
            }
        }
      }

    }

    task "flyway-service" {
      driver = "docker"
      config {
        image = "${image}"
        volumes = [
          "flyway/conf/flyway.conf:/flyway/conf/flyway.conf"
        ]
        args = [
          "migrate"
        ]
      }
      resources {
        cpu    = "${cpu}" # MHz
        memory = "${memory}" # MB
      }

      template {
        destination = "flyway/conf/flyway.conf"
        env         = true
        data        = <<EOH
flyway.url=jdbc:${jdbc_protocol}://{{ env "NOMAD_UPSTREAM_ADDR_${jdbc_host}" }}/${jdbc_database}
flyway.user=${jdbc_username}
flyway.password=${jdbc_password}
flyway.schemas=${jdbc_schema}
EOH
      }
    }
  }
}
