module "network" { 
  source = "./modules/network"
  gcp_region = "${var.gcp_region}"
  gcp_nat_zone = "${var.gcp_nat_zone}"
}

module "database" {
  source = "./modules/database"
  db_instance_tier = "${var.db_instance_tier}"
  db_username = "${var.db_username}"
  db_password = "${var.db_password}"
  db_instance_name = "${var.db_instance_name}"
  db_db = "${var.db_db}"
  gcp_region = "${var.gcp_region}"
  nat_ip = "${module.network.nat_ip}"
}

module "wordpress" {
  source = "./modules/wordpress"
  db_username = "${var.db_username}"
  db_password = "${var.db_password}"
  db_db = "${var.db_db}"
  db_address = "${module.database.db_address}"
  gcp_region = "${var.gcp_region}"
  gcp_subnet = "${module.network.subnetwork}"
  health_check = "${module.loadbalancer.health_check}"
  wordpress_distribution_zones = "${var.wordpress_distribution_zones}"
  wordpress_tg_size = "${var.wordpress_tg_size}"
  wp_install_admin_username = "${var.wp_install_admin_username}"
  wp_install_admin_email = "${var.wp_install_admin_email}"
  wp_install_admin_password = "${var.wp_install_admin_password}"
  wp_install_domain = "${module.network.nat_ip}"
}

module "loadbalancer" {
  source = "./modules/loadbalancer"
  healthcheck_request_path = "${var.healthcheck_request_path}"
  wordpress_igm = "${module.wordpress.wordpress_igm}"
}