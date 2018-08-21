// Wordpress resources

// Wordpress startup script
data "template_file" "wordpress_startup_script" {
  template = "${file("startup-scripts/wordpress.sh.tpl")}"
  vars {
    db_host = "${var.db_address}"
    db_username = "${var.db_username}"
    db_password = "${var.db_password}"
    db_db = "${var.db_db}"
    wp_install_admin_username = "${var.wp_install_admin_username}"
    wp_install_admin_email = "${var.wp_install_admin_email}"
    wp_install_admin_password = "${var.wp_install_admin_password}"
    wp_install_domain = "${var.wp_install_domain}"
  }
}

// Instance template
resource "google_compute_instance_template" "wordpress_instance_template" {
  tags = ["wordpress", "nat-guest"]
  name_prefix = "wordpress-"
  machine_type = "g1-small"
  can_ip_forward = false
  disk {
    source_image = "debian-cloud/debian-9"
    auto_delete = true
    boot = true
  }
  network_interface {
    subnetwork = "${var.gcp_subnet}"
  }
  metadata_startup_script = "${data.template_file.wordpress_startup_script.rendered}"
  lifecycle {
    create_before_destroy = true
  }
}

resource "google_compute_region_instance_group_manager" "wordpress_instance_group" {
  name = "wordpress-igm"
  base_instance_name = "wordpress-igm"
  instance_template = "${google_compute_instance_template.wordpress_instance_template.self_link}"
  region = "${var.gcp_region}"
  distribution_policy_zones = "${var.wordpress_distribution_zones}"
  target_size = "${var.wordpress_tg_size}"
}

// OUTPUT
output "wordpress_igm" {
  value = "${google_compute_region_instance_group_manager.wordpress_instance_group.instance_group}"
}