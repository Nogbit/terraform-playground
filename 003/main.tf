provider "google" {
  project = "terraform-playground-236106"
  region = "us-west1"
  zone = "us-west1-a"
}

// a silly var but it works and a neat way of getting data to the script
data "template_file" "startup_script" {
  template = "${file("${path.module}/templates/startup.tpl")}"
  vars {
    network = "${google_compute_firewall.http.name}"
  }
}

resource "google_compute_instance" "web" {
  name = "lab003-web" 
  machine_type = "f1-micro"

  boot_disk {
    initialize_params {
      image = "debian-cloud/debian-9"
    }
  }

  metadata_startup_script = "${data.template_file.startup_script.rendered}"

  network_interface {
    network = "default"

    access_config {

    }
  }

  metadata {
    sshKeys = "${var.ssh_user}:${file("~/.ssh/id_rsa.pub")}"
  }

  tags = ["http"]
}

resource "google_compute_firewall" "http" {
  name = "default-allow-http" 
  network = "default"

  allow {
    protocol = "tcp"
    ports = ["80", "22"]
  }

  source_ranges = ["0.0.0.0/0"]
  target_tags = ["http"]
}

output "ip" {
  value = "${google_compute_instance.web.network_interface.0.access_config.0.nat_ip}"
}

