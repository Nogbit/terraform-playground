# Playing with Terraform

Using the official docs and online guides to play with the awesome sauce that is Terraform.

To cleanup all the labs in one shot from the repo root...

    for D in */; do (cd $D && terraform destroy -force); done

## 001 - VM

A simple starter that creates a VM with SSH credentials from the environment that apply is ran.

    cd 001 
    terraform apply

## 002 - HTTP Function

Creates an archive and storage bucket. Uploads archive to the bucket.  Creates an http function using the JS from the bucket.  [Tutorial source](https://opencredo.com/blogs/google-cloudfunctions-with-terraform/).

    cd 002
    terraform init && terraform apply
    curl [output.url]

## 003 - Simple Apache Server

A simple server that uses a startup script with variables passed into it.

    cd 003
    terraform init && terraform apply
    curl [output ip]

## 004 - Simple Cloud SQL

A Cloud SQL server that permits a single VM to connect to it (or anything really, it's public).  

    cd 004
    terraformm init && terraform apply
    ssh [output vm-ip]
    mycli -u joe -h [output sql-ip]

Also connect to it from glcoud CLI

    gcloud sql connect master-instance --user=joe

## 005 - Private Cloud SQL

While [this example here](https://github.com/steinim/gcp-terraform-workshop/tree/task6) is pretty neat and modular, the DB is not private and sits on the internet for `0.0.0.0/0`.

I would like to take that example and put the db on the private network per GCP capabilities.

There is [currently a bug](https://github.com/terraform-providers/terraform-provider-google/issues/3342) for putting Cloud SQL on a private network, at least a bug with their own implemenation that is.

## 006 - PubSub

A set of 3 topics and 3 subscribers.  Messages are sent to different topics based on the the FizzBuzz number.  The respective GCP Function will then be triggered and log that it recieved the message.

    cd 006
    terraform init && terraform apply
    curl [output.url]?count[num of messages]