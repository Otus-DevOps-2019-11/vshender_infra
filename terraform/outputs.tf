output "app_instance_ips" {
  value = google_compute_instance.app[*].network_interface[0].access_config[0].nat_ip
}

output "app_external_ip" {
  value = google_compute_global_address.reddit_app_global_address.address
}
