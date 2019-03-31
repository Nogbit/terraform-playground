provider "google" {
  project = "terraform-playground-236106"
  region = "us-west1"
  zone = "us-west1-a"
}

// a silly var but it works and a neat way of getting data to the script
data "template_file" "startup_script" {
  template = "${file("${path.module}/templates/startup.sh")}"
}

resource "google_compute_instance" "app" {
  name                    = "app" 
  machine_type            = "f1-micro"
  metadata_startup_script = "${data.template_file.startup_script.rendered}"

  boot_disk {
    initialize_params {
      image = "debian-cloud/debian-9"
    }
  }

  network_interface {
    network = "default"

    access_config { }
  }

  metadata {
    sshKeys = "${var.ssh_user}:${file("~/.ssh/id_rsa.pub")}"
  }
}

resource "google_sql_database_instance" "master" {
  name = "master-instance"
  database_version = "MYSQL_5_6"
  settings {
    tier = "db-f1-micro"

    ip_configuration {
      ipv4_enabled = true
      authorized_networks = [
        {
          name = "${google_compute_instance.app.name}"
          value = "${google_compute_instance.app.network_interface.0.access_config.0.nat_ip}"
        }
      ]
    }
  }
}

resource "google_sql_user" "users" {
  name     = "joe" 
  instance = "${google_sql_database_instance.master.name}"
  password = "changeme"
}

output "vm-ip" {
  value = "${google_compute_instance.app.network_interface.0.access_config.0.nat_ip}"
}
output "sql-ip" {
  value = "${google_sql_database_instance.master.public_ip_address}"
}