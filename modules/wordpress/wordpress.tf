// Wordpress resources

// Wordpress startup script
data "template_file" "wordpress_startup_script" {
  template = "${file("startup-scripts/wordpress.sh.tpl")}"
  vars {
    db_host = "${google_sql_database_instance.wordpress-database.self_link}"
    db_username = "${var.db_username}"
    db_password = "${var.db_password}"
    db_db = "${var.db_db}"
  }
}

// Instance template
resource "google_compute_instance_template" "wordpress_instance_template" {
  tags = ["wordpress", "nat-guest"]
  machine_type = "g1-small"
  can_ip_forward = false
  disk {
    source_image = "debian-cloud/debian-9"
    auto_delete = true
    boot = true
  }
  network_interface {
    subnetwork = "${google_compute_subnetwork.us-central1.self_link}"
  }
  metadata_startup_script = "${data.template_file.wordpress_startup_script.rendered}"
}
