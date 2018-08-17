// Database Instance
resource "google_sql_database_instance" "wordpress-database-instance" {
  name = "${var.db_instance_name}"
  database_version = "MYSQL_5_7"
  region = "${var.gcp_region}"
  settings {
    tier = "${var.db_instance_tier}"
    ip_configuration {
      authorized_networks {
        value = "${var.nat_ip}"
        name = "NAT Instance"
      }
    }
  }
}

// Database
resource "google_sql_database" "wordpress-database" {
  name = "${var.db_db}"
  instance = "${google_sql_database_instance.wordpress-database-instance.name}"
}

// Database user
resource "google_sql_user" "wordpress-database-rootuser" {
  name     = "${var.db_username}"
  instance = "${google_sql_database_instance.wordpress-database-instance.name}"
  host     = "%"
  password = "${var.db_password}"
}
