terraform {
  # Terraform version
  required_version = "~>0.12.0"
}

provider "google" {
  # Provider version
  version = "2.15"

  # Project ID
  project = var.project

  region = var.region
}

resource "google_compute_instance" "app" {
  name = "reddit-app"
  machine_type = "g1-small"
  zone = "europe-west1-b"

  boot_disk {
    initialize_params {
      image = var.disk_image
    }
  }

  network_interface {
    network = "default"
    access_config {}
  }

  tags = ["reddit-app"]

  metadata = {
    ssh-keys = "appuser:${file(var.public_key_path)}"
  }

  connection {
    type = "ssh"
    host = self.network_interface[0].access_config[0].nat_ip
    user = "appuser"
    agent = false
    private_key = file("~/.ssh/appuser")
  }

  provisioner "file" {
    source = "files/puma.service"
    destination = "/tmp/puma.service"
  }

  provisioner "remote-exec" {
    script = "files/deploy.sh"
  }
}

resource "google_compute_firewall" "firewall_puma" {
  name = "allow-puma-default"

  # Network name in which the rule applies
  network = "default"

  # Allowed access
  allow {
    protocol = "tcp"
    ports = ["9292"]
  }

  # Addresses for which access is allowed
  source_ranges = ["0.0.0.0/0"]

  # The rule applies to instances with the tags listed
  target_tags = ["reddit-app"]
}
