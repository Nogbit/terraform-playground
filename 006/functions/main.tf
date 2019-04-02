// all the functions put their objects here
resource "google_storage_bucket" "bucket" {
  name = "${var.lab}-functions"
}

module "producer" {
  source = "./producer"
  bucket = "${google_storage_bucket.bucket.name}"
}

module "subscriber" {
  source  = "./subscriber"
  bucket  = "${google_storage_bucket.bucket.name}"
  fizzers = "${var.fizzers}"  
}

output "url" {
  value = "${module.producer.function}"
}
