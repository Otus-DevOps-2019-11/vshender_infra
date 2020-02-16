resource "google_compute_global_forwarding_rule" "reddit_app_forwarding_rule" {
  name = "reddit-app-forwarding-rule"

  load_balancing_scheme = "EXTERNAL"

  ip_address = google_compute_global_address.reddit_app_global_address.self_link
  port_range = "80"

  target = google_compute_target_http_proxy.reddit_app_target_http_proxy.self_link
}

resource "google_compute_global_address" "reddit_app_global_address" {
  name = "reddit-app-global-address"
}

resource "google_compute_target_http_proxy" "reddit_app_target_http_proxy" {
  name    = "reddit-app-target-http-proxy"
  url_map = google_compute_url_map.reddit_app_load_balancer.self_link
}

resource "google_compute_url_map" "reddit_app_load_balancer" {
  name            = "reddit-app-load-balancer"
  default_service = google_compute_backend_service.reddit_app_backend_service.self_link
}

resource "google_compute_backend_service" "reddit_app_backend_service" {
  name      = "reddit-app-backend-service"
  protocol  = "HTTP"
  port_name = "http"

  backend {
    group = google_compute_instance_group.reddit_app_instance_group.self_link
  }

  health_checks = [google_compute_http_health_check.reddit_app_healthcheck.self_link]
}

resource "google_compute_instance_group" "reddit_app_instance_group" {
  name = "reddit-app-instance-group"
  zone = var.zone

  instances = google_compute_instance.app[*].self_link

  named_port {
    name = "http"
    port = "9292"
  }
}

resource "google_compute_http_health_check" "reddit_app_healthcheck" {
  name               = "reddit-app-healthcheck"
  port               = 9292
  request_path       = "/"
  check_interval_sec = 1
  timeout_sec        = 1
}
