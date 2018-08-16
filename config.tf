// Google Cloud provider
provider "google" {
  project     = "cr-lab-mtaylor-1508183413"
  region      = "${var.gcp_region}"
}

terraform {
  backend "gcs" {
    bucket = "matalo-wordpress-tfstate"
    prefix = "workshop/terraform.tfstate"
    region = "us-central1"
  }
}