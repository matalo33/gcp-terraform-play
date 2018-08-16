// Database
resource "google_sql_database_instance" "wordpress-database" {
  name = "${var.db_instance_name}"
  database_version = "MYSQL_5_7"
  region = "${var.gcp_region}"
  settings {
    tier = "${var.db_instance_tier}"
    # ip_configuration {
    #   authorized_networks = ["${var.nat_ip}"]
    # }
  }
}