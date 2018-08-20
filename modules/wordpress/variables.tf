variable "db_username" {
  type = "string"
}

variable "db_password" {
  type = "string"
}

variable "db_db" {
  type = "string"
}

variable "db_address" {
  type = "string"
}

variable "gcp_region" {
  type = "string"
}

variable "gcp_subnet" {
  type = "string"
}

variable "health_check" {
  type = "string"
}

variable "wordpress_distribution_zones" {
  type = "list"
}

variable "wordpress_tg_size" {
  type = "string"
}