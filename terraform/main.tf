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

resource "google_compute_project_metadata_item" "default" {
  key   = "ssh-keys"
  value = join("\n", [for user in var.users : "${user}:${file(var.public_key_path)}"])
}

resource "google_compute_instance" "app" {
  name         = "reddit-app"
  machine_type = "g1-small"
  zone         = var.zone

  boot_disk {
    initialize_params {
      image = var.disk_image
    }
  }

  network_interface {
    network = "default"
    access_config {
      nat_ip = google_compute_address.app_ip.address
    }
  }

  tags = ["reddit-app"]

  connection {
    type        = "ssh"
    host        = self.network_interface[0].access_config[0].nat_ip
    user        = var.users[0]
    agent       = false
    private_key = file(var.private_key_path)
  }

  provisioner "file" {
    source      = "files/puma.service"
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
    ports    = ["9292"]
  }

  # Addresses for which access is allowed
  source_ranges = ["0.0.0.0/0"]

  # The rule applies to instances with the tags listed
  target_tags = ["reddit-app"]
}

resource "google_compute_firewall" "firewall_ssh" {
  name        = "default-allow-ssh"
  description = "Allow SSH from anywhere"
  network     = "default"
  priority    = 65534

  allow {
    protocol = "tcp"
    ports    = ["22"]
  }

  source_ranges = ["0.0.0.0/0"]
}

resource "google_compute_address" "app_ip" {
  name = "reddit-app-ip"
}
