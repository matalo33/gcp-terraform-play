// Google Cloud provider
provider "google" {
  project     = "cr-lab-mtaylor-1708185523"
  region      = "${var.gcp_region}"
}

terraform {
  backend "gcs" {
    bucket = "matalo-wordpress-tfstate-1"
    prefix = "workshop/terraform.tfstate"
    region = "us-central1"
  }
}
