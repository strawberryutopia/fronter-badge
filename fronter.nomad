job "screen_service" {
  region = "europe"
  datacenters = ["davinhart-castle"]
  type = "service"

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

    task "draw" {
      driver = "raw_exec"
      # Need to be root to draw to frame buffer
      user = "root"

      config {
        command = "/home/pi/fronter/update-screen.sh"
      }


      # TODO: https://www.nomadproject.io/docs/job-specification/artifact#download-using-git
      #
      # The "artifact" stanza instructs Nomad to download an artifact from a
      # remote source prior to starting the task. This provides a convenient
      # mechanism for downloading configuration files or data needed to run the
      # task. It is possible to specify the "artifact" stanza multiple times to
      # download multiple artifacts.
      #
      # For more information and examples on the "artifact" stanza, please see
      # the online documentation at:
      #
      #     https://www.nomadproject.io/docs/job-specification/artifact
      #
      # artifact {
      #   source = "http://foo.com/artifact.tar.gz"
      #   options {
      #     checksum = "md5:c4aa853ad2215426eb7d70a21922e794"
      #   }
      # }


      resources {
        cpu    = 32
        memory = 64
      }
    }

    task "get_fronter" {
      driver = "raw_exec"
      # Need to be root to draw to frame buffer
      user = "root"

      config {
        command = "/home/pi/fronter/get-fronter.sh"
      }

      resources {
        cpu    = 32
        memory = 64
      }
    }
  }
}
