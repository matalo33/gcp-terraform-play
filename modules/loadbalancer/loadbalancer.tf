resource "google_compute_health_check" "wordpress_health_check" {
  name = "wordpress-health-check"
  timeout_sec = 2
  check_interval_sec = 2

  http_health_check {
    request_path = "${var.healthcheck_request_path}"
  }
}

// OUTPUTS
output "health_check" {
  value = "${google_compute_health_check.wordpress_health_check.self_link}"
}