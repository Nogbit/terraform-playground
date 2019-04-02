locals {
  function_name = "${data.archive_file.topic_trigger.output_md5}.zip"
}

# Our code for the function itself
data "archive_file" "topic_trigger" {
  type        = "zip"
  output_path = "${path.module}/files/out.zip"
  source {
    content  = "${file("${path.module}/files/out.py")}"
    filename = "main.py"
  }
  source {
    content  = "${file("${path.module}/files/requirements.txt")}"
    filename = "requirements.txt"
  }
}

# The bucket that will store our FizzBuzz message producer
resource "google_storage_bucket_object" "archive" {
  name       = "subscriber-${local.function_name}"
  bucket     = "${var.bucket}"
  source     = "${path.module}/files/out.zip"
  depends_on = ["data.archive_file.topic_trigger"]
}

# All functions share the same source code and bucket object
# ..though really that could be dynamic as well
resource "google_cloudfunctions_function" "default" {
  count                 = "${length(var.fizzers)}"
  name                  = "subscriber-${var.fizzers[count.index]}"  
  entry_point           = "write"
  runtime               = "python37"
  available_memory_mb   = 512
  timeout               = 60
  source_archive_bucket = "${var.bucket}"
  source_archive_object = "${google_storage_bucket_object.archive.name}"
  event_trigger = {
    event_type = "google.pubsub.topic.publish"
    resource = "${var.fizzers[count.index]}"
  }
}