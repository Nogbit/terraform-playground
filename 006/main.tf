provider "google" {
  project = "${var.project}"
  region = "us-east1"
  zone = "us-east1-a"
}

locals {
  fizzers = ["Fizz", "Buzz", "FizzBuzz"] 
}

# Our topics and subscribers
module "pubsub" {
  source  = "./pubsub"
  lab     = "${var.lab}"
  fizzers = "${local.fizzers}"
}

# Message consumers and the producer
module "functions" {
  source  = "./functions"
  lab     = "${var.lab}"
  fizzers = "${local.fizzers}"
}

output "url" {
  value = ""
  value = "${module.functions.url}"
}
