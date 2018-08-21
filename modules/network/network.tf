// Network

// VPC
resource "google_compute_network" "wordpress-network" {
  name = "wordpress-network"
  auto_create_subnetworks = "false"
}

// Subnet
resource "google_compute_subnetwork" "us-central1" {
  name = "us-central1"
  network = "${google_compute_network.wordpress-network.self_link}"
  ip_cidr_range = "10.50.0.0/24"
  region = "us-central1"
}

// NAT Instance
resource "google_compute_instance" "nat-instance" {
  name = "nat-instance"
  machine_type = "g1-small"
  zone = "us-central1-a"
  can_ip_forward = true
  tags = ["nat", "ext-ssh"]
  boot_disk {
    initialize_params {
      image = "debian-cloud/debian-9"
    }
  }
  network_interface {
    subnetwork = "${google_compute_subnetwork.us-central1.self_link}"
    access_config {}
  }
  metadata_startup_script = "${file("startup-scripts/nat.sh")}"
}

// Firewall rule 'allow-int-to-nat' for tag 'nat'
resource "google_compute_firewall" "firewall-allow-int-to-nat" {
  name = "allow-int-to-nat"
  network = "${google_compute_network.wordpress-network.self_link}"
  allow {
    protocol = "all"
  }
  source_tags = ["nat-guest"]
  target_tags = ["nat"]
}

// Firewall rule 'ext-ssh'
resource "google_compute_firewall" "firewall-allow-ext-ssh" {
  name = "allow-ext-ssh"
  network = "${google_compute_network.wordpress-network.self_link}"
  allow {
    protocol = "tcp"
    ports = ["22"]
  }
  source_ranges = ["0.0.0.0/0"]
  target_tags = ["ext-ssh"]
}

// Firewall rule 'nat-guests-ssh
resource "google_compute_firewall" "firewall-allow-natguests-ssh" {
  name = "allow-ssh-nat-guests"
  network = "${google_compute_network.wordpress-network.self_link}"
  allow {
    protocol = "tcp"
    ports = ["22"]
  }
  source_tags = ["nat"]
  target_tags = ["nat-guest"]
}

// Firewall rule 'wordpress-http
resource "google_compute_firewall" "firewall-allow-wordpress-http" {
  name = "allow-http-wordpress"
  network = "${google_compute_network.wordpress-network.self_link}"
  allow {
    protocol = "tcp"
    ports = ["80"]
  }
  source_ranges = ["0.0.0.0/0"]
  target_tags = ["wordpress"]
}

// Private instances routing to NAT
resource "google_compute_route" "private-instances-to-nat" {
  name = "private-instances-to-nat"
  dest_range = "0.0.0.0/0"
  tags = ["nat-guest"]
  network = "${google_compute_network.wordpress-network.self_link}"
  next_hop_instance = "${google_compute_instance.nat-instance.self_link}"
  next_hop_instance_zone = "${var.gcp_nat_zone}"
}

# // Private Instance
# resource "google_compute_instance" "private-instance" {
#   name = "private-instance"
#   machine_type = "g1-small"
#   zone = "us-central1-a"
#   tags = ["nat-guest"]
#   boot_disk {
#     initialize_params {
#       image = "debian-cloud/debian-9"
#     }
#   }
#   network_interface {
#     subnetwork = "${google_compute_subnetwork.us-central1.self_link}"
#     access_config {
#       nat_ip = "146.148.46.182"
#     }
#   }
# }

// OUTPUTS
output "nat_ip" {
  value = "${google_compute_instance.nat-instance.network_interface.0.access_config.0.assigned_nat_ip}"
}

output "subnetwork" {
  value = "${google_compute_subnetwork.us-central1.self_link}"
}