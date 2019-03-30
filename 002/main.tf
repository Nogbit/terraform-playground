provider "google" {
  project = "terraform-playground-236106"
  region  = "us-central1"
  zone    = "us-central1-a"
}

resource "google_storage_bucket" "bucket" {
  name = "httpfunction-002"
}

# Our code for the function itself, source at ./files/index.js
data "archive_file" "http_trigger" {
  type        = "zip"
  output_path = "${path.module}/files/http_trigger.zip"
  source {
    content  = "${file("${path.module}/files/http_trigger.js")}"
    filename = "index.js"
  }
}

# The bucket that will store our NodeJS function
resource "google_storage_bucket_object" "archive" {
  name       = "http_trigger.zip"
  bucket     = "${google_storage_bucket.bucket.name}"
  source     = "${path.module}/files/http_trigger.zip"
  depends_on = ["data.archive_file.http_trigger"]
}

# The definition for our http function
resource "google_cloudfunctions_function" "default" {
  name                  = "hello-world"
  entry_point           = "helloGET"
  available_memory_mb   = 512
  timeout               = 60
  trigger_http          = true
  source_archive_bucket = "${google_storage_bucket.bucket.name}"
  source_archive_object = "${google_storage_bucket_object.archive.name}"
  labels {
    lab = "002"
  }
}

output "url" {
  value = "${google_cloudfunctions_function.default.https_trigger_url}" 
}
