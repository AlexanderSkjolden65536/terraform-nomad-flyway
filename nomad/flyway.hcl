job "flyway" {
  type        = "batch"
  datacenters = ["${datacenters}"]
  namespace   = "${namespace}"

  update {
    max_parallel      = 1
    health_check      = "checks"
    min_healthy_time  = "10s"
    healthy_deadline  = "55m"
    progress_deadline = "1h"
%{ if use_canary }
    canary            = 1
    auto_promote      = true
    auto_revert       = true
%{ endif }
    stagger           = "30s"
  }

  group "flyway" {
    count = 1
    network {
      mode = "bridge"
    }

    service {
      name = "${service_name}"
      port = "${port}"
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
        sidecar_service {}
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
      }
      resources {
        cpu    = "${cpu}" # MHz
        memory = "${memory}" # MB
      }
    }
  }
}
