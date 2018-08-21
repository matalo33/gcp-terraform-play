resource "google_compute_health_check" "wordpress_health_check" {
  name = "wordpress-health-check"
  timeout_sec = 2
  check_interval_sec = 2

  http_health_check {
    request_path = "${var.healthcheck_request_path}"
  }
}

resource "google_compute_backend_service" "wordpress-backend" {
  name        = "wordpress-backend"
  port_name   = "http"
  protocol    = "HTTP"
  timeout_sec = 10

  backend {
    group = "${var.wordpress_igm}"
  }

  health_checks = ["${google_compute_health_check.wordpress_health_check.self_link}"]
}

resource "google_compute_target_http_proxy" "wordpress-proxy" {
  name        = "wordpress-proxy"
  url_map     = "${google_compute_url_map.wordpress-urlmap.self_link}"
}

resource "google_compute_url_map" "wordpress-urlmap" {
  name        = "url-map"
  default_service = "${google_compute_backend_service.wordpress-backend.self_link}"
}

resource "google_compute_global_forwarding_rule" "wordpress-frontend" {
  name       = "default-rule"
  target     = "${google_compute_target_http_proxy.wordpress-proxy.self_link}"
  port_range = "80"
}

// OUTPUTS
output "health_check" {
  value = "${google_compute_health_check.wordpress_health_check.self_link}"
}