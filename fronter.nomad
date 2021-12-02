job "screen_service" {
  region = "europe"
  datacenters = ["davinhart-castle"]
  type = "service"

  constraint {
    attribute    = "${meta.cached_binaries}"
    set_contains = "jq,fbi"
  }

  constraint {
    attribute = "${meta.has_framebuffer}"
    value     = true
  }

  group "screen" {
    count = 1

    restart {
      attempts = 2
      interval = "30m"
      delay = "15s"
      mode = "fail"
    }

    ephemeral_disk {
      size = 128
    }

    # TODO: Affinity to RPi nodes with screens?

    task "update" {
      driver = "raw_exec"
      # Need to be root to draw to frame buffer
      user = "root"

      config {
        command = "local/repo/update-screen.sh"
      }

      artifact {
        source      = "git::https://github.com/strawberryutopia/fronter-badge"
        destination = "local/repo"
      }

      resources {
        cpu    = 32
        memory = 64
      }
    }
  }
}
