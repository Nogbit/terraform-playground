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

### 005 - Private Cloud SQL

Soon...start messing around with networks more and more modular setup.