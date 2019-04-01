provider "google" {
  project = "terraform-playground-236106"
  region = "us-west1"
  zone = "us-west1-a"
}

// Our VM with SSH for making SQL querries
module "bastion" {
  source = "./bastion"
}

// Our private network for SQL server
//TBD