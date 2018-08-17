

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