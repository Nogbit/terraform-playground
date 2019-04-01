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