// Variables

variable "gcp_region" {
  default = "us-central1"
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
