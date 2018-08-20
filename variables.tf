// Variables

variable "gcp_region" {
  default = "us-central1"
}

variable "wordpress_distribution_zones" {
  default = ["us-central1-b", "us-central1-c", "us-central1-f"]
}

variable "wordpress_tg_size" {
  default = "1"
}

variable "gcp_nat_zone" {
  default = "us-central1-a"
}

variable "db_instance_tier" {
  default = "db-g1-small"
}

variable "db_username" {
  default = "root"
}

variable "db_password" {
  default = "xz61bzhAGka7"
}

variable "db_instance_name" {
  default = "wordpress-db6"
}

variable "db_db" {
  default = "wordpress"
}

variable "healthcheck_request_path" {
  default = "/"
}

#variable "wp_install_domain" 
variable "wp_install_admin_username" {
  default = "matalo"
}

variable "wp_install_admin_email" {
  default = "matthew.taylor@cloudreach.com"
}

variable "wp_install_admin_password" {
  default = "herebedragons"
}