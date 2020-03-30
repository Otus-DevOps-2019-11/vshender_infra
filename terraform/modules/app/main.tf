resource "google_compute_instance" "app" {
  name         = "reddit-app"
  machine_type = "g1-small"
  zone         = var.zone

  tags = ["reddit-app"]

  boot_disk {
    initialize_params {
      image = var.app_disk_image
    }
  }

  network_interface {
    network = "default"
    access_config {
      nat_ip = google_compute_address.app_ip.address
    }
  }

  metadata = {
    ssh-keys = "appuser:${file(var.public_key_path)}"
  }
}

resource "google_compute_firewall" "firewall_puma" {
  name = "allow-puma-default"

  # Network name in which the rule applies
  network = "default"

  # Allowed access
  allow {
    protocol = "tcp"
    ports    = ["80", "9292"]
  }

  # Addresses for which access is allowed
  source_ranges = ["0.0.0.0/0"]

  # The rule applies to instances with the tags listed
  target_tags = ["reddit-app"]
}

resource "google_compute_address" "app_ip" {
  name = "reddit-app-ip"
}
