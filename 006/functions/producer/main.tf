locals {
  function_name = "${data.archive_file.http_trigger.output_md5}.zip"
}

# Our code for the function itself
data "archive_file" "http_trigger" {
  type        = "zip"
  output_path = "${path.module}/files/http_trigger.zip"
  source {
    content  = "${file("${path.module}/files/http_trigger.py")}"
    filename = "main.py"
  }
  source {
    content  = "${file("${path.module}/files/requirements.txt")}"
    filename = "requirements.txt"
  }
}

# The bucket that will store our FizzBuzz message producer
resource "google_storage_bucket_object" "archive" {
  name       = "producer-${local.function_name}"
  bucket     = "${var.bucket}"
  source     = "${path.module}/files/http_trigger.zip"
  depends_on = ["data.archive_file.http_trigger"]
}

# Curl this function URL with ?count=[num of messages]
resource "google_cloudfunctions_function" "default" {
  name                  = "producer-fizzbuzz"
  entry_point           = "produce"
  runtime               = "python37"
  available_memory_mb   = 512
  timeout               = 60
  trigger_http          = true
  source_archive_bucket = "${var.bucket}"
  source_archive_object = "${google_storage_bucket_object.archive.name}"
}

output "function" {
  value = "${google_cloudfunctions_function.default.https_trigger_url}" 
}
